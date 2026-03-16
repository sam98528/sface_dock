// windows/plugin/named_pipe_client.cpp
#include "named_pipe_client.h"
#include <string>
#include <vector>
#include <mutex>

struct PipeClientHandle {
    HANDLE pipeHandle;
    std::string pipeName;
    std::mutex mutex;
    bool connected;
    DWORD lastError;
    
    static constexpr size_t BUFFER_SIZE = 65536;
    
    PipeClientHandle(const std::string& name) 
        : pipeHandle(INVALID_HANDLE_VALUE)
        , pipeName(name)
        , connected(false)
        , lastError(0) {
    }
    
    ~PipeClientHandle() {
        close();
    }
    
    void close() {
        std::lock_guard<std::mutex> lock(mutex);
        if (pipeHandle != INVALID_HANDLE_VALUE) {
            CloseHandle(pipeHandle);
            pipeHandle = INVALID_HANDLE_VALUE;
        }
        connected = false;
    }
};

extern "C" {

EXPORT_FUNC void* createPipeClient(const char* pipeName) {
    if (!pipeName) {
        return nullptr;
    }
    return new PipeClientHandle(std::string(pipeName));
}

EXPORT_FUNC int connectPipe(void* client) {
    if (!client) {
        return 0;
    }
    
    PipeClientHandle* handle = static_cast<PipeClientHandle*>(client);
    std::lock_guard<std::mutex> lock(handle->mutex);
    
    if (handle->connected) {
        return 1;
    }
    
    // Convert pipe name to wide string
    std::wstring widePipeName(handle->pipeName.begin(), handle->pipeName.end());
    
    // Try to connect to named pipe
    handle->pipeHandle = CreateFileW(
        widePipeName.c_str(),
        GENERIC_READ | GENERIC_WRITE,
        0,
        nullptr,
        OPEN_EXISTING,
        FILE_FLAG_OVERLAPPED,
        nullptr
    );
    
    if (handle->pipeHandle == INVALID_HANDLE_VALUE) {
        handle->lastError = GetLastError();
        
        if (handle->lastError == ERROR_PIPE_BUSY) {
            // Short timeout - Dart retry loop handles reconnection
            if (!WaitNamedPipeW(widePipeName.c_str(), 200)) {
                handle->lastError = GetLastError();
                return 0;
            }
            
            handle->pipeHandle = CreateFileW(
                widePipeName.c_str(),
                GENERIC_READ | GENERIC_WRITE,
                0,
                nullptr,
                OPEN_EXISTING,
                FILE_FLAG_OVERLAPPED,
                nullptr
            );
            
            if (handle->pipeHandle == INVALID_HANDLE_VALUE) {
                handle->lastError = GetLastError();
            }
        }
        
        if (handle->pipeHandle == INVALID_HANDLE_VALUE) {
            return 0;
        }
    }
    
    // Set pipe mode
    DWORD mode = PIPE_READMODE_MESSAGE;
    if (!SetNamedPipeHandleState(handle->pipeHandle, &mode, nullptr, nullptr)) {
        handle->lastError = GetLastError();
        CloseHandle(handle->pipeHandle);
        handle->pipeHandle = INVALID_HANDLE_VALUE;
        return 0;
    }
    
    handle->connected = true;
    return 1;
}

EXPORT_FUNC unsigned long getLastError(void* client) {
    if (!client) {
        return 0;
    }
    PipeClientHandle* handle = static_cast<PipeClientHandle*>(client);
    std::lock_guard<std::mutex> lock(handle->mutex);
    return handle->lastError;
}

EXPORT_FUNC bool sendMessage(void* client, const char* message) {
    if (!client || !message) {
        return false;
    }
    
    PipeClientHandle* handle = static_cast<PipeClientHandle*>(client);
    std::lock_guard<std::mutex> lock(handle->mutex);
    
    if (!handle->connected || handle->pipeHandle == INVALID_HANDLE_VALUE) {
        return false;
    }
    
    DWORD messageSize = static_cast<DWORD>(strlen(message));
    DWORD bytesWritten = 0;
    
    // Send message size first (4 bytes, little-endian)
    if (!WriteFile(handle->pipeHandle, &messageSize, sizeof(messageSize), &bytesWritten, nullptr)) {
        DWORD error = GetLastError();
        if (error == ERROR_BROKEN_PIPE || error == ERROR_PIPE_NOT_CONNECTED) {
            handle->connected = false;
        }
        return false;
    }
    
    // Send message body
    if (messageSize > 0) {
        if (!WriteFile(handle->pipeHandle, message, messageSize, &bytesWritten, nullptr)) {
            DWORD error = GetLastError();
            if (error == ERROR_BROKEN_PIPE || error == ERROR_PIPE_NOT_CONNECTED) {
                handle->connected = false;
            }
            return false;
        }
    }
    
    return true;
}

EXPORT_FUNC bool receiveMessage(void* client, char* buffer, int bufferSize, int* messageLength) {
    if (!client || !buffer || bufferSize <= 0 || !messageLength) {
        return false;
    }
    
    PipeClientHandle* handle = static_cast<PipeClientHandle*>(client);
    std::lock_guard<std::mutex> lock(handle->mutex);
    
    if (!handle->connected || handle->pipeHandle == INVALID_HANDLE_VALUE) {
        return false;
    }
    
    *messageLength = 0;
    
    // Peek: get available count and first 4 bytes (message size) WITHOUT consuming.
    // Only ReadFile when full message is in pipe so we never block the UI.
    DWORD bytesAvailable = 0;
    DWORD messageSize = 0;
    DWORD bytesRead = 0;
    if (!PeekNamedPipe(handle->pipeHandle, &messageSize, sizeof(messageSize), &bytesRead, &bytesAvailable, nullptr)) {
        DWORD error = GetLastError();
        if (error == ERROR_BROKEN_PIPE || error == ERROR_PIPE_NOT_CONNECTED) {
            handle->connected = false;
        }
        return false;
    }
    if (bytesAvailable < sizeof(DWORD)) {
        return false;
    }
    if (messageSize == 0 || messageSize > static_cast<DWORD>(bufferSize - 1)) {
        return false;
    }
    if (bytesAvailable < sizeof(DWORD) + messageSize) {
        return false; // Full message not in pipe yet - retry later, do not block
    }
    
    // Full message present: consume 4-byte size then body.
    if (!ReadFile(handle->pipeHandle, &messageSize, sizeof(messageSize), &bytesRead, nullptr)) {
        DWORD error = GetLastError();
        if (error == ERROR_BROKEN_PIPE || error == ERROR_PIPE_NOT_CONNECTED) {
            handle->connected = false;
        }
        return false;
    }
    if (!ReadFile(handle->pipeHandle, buffer, messageSize, &bytesRead, nullptr)) {
        DWORD error = GetLastError();
        if (error == ERROR_BROKEN_PIPE || error == ERROR_PIPE_NOT_CONNECTED) {
            handle->connected = false;
        }
        return false;
    }
    buffer[bytesRead] = '\0';
    *messageLength = static_cast<int>(bytesRead);
    return true;
}

EXPORT_FUNC bool isConnected(void* client) {
    if (!client) {
        return false;
    }
    
    PipeClientHandle* handle = static_cast<PipeClientHandle*>(client);
    std::lock_guard<std::mutex> lock(handle->mutex);
    return handle->connected && handle->pipeHandle != INVALID_HANDLE_VALUE;
}

EXPORT_FUNC void closePipe(void* client) {
    if (!client) {
        return;
    }
    
    PipeClientHandle* handle = static_cast<PipeClientHandle*>(client);
    handle->close();
    delete handle;
}

} // extern "C"
