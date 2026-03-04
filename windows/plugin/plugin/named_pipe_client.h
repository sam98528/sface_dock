// windows/plugin/named_pipe_client.h
#pragma once

#ifdef _WIN32
    #ifndef WIN32_LEAN_AND_MEAN
        #define WIN32_LEAN_AND_MEAN
    #endif
    #ifndef NOMINMAX
        #define NOMINMAX
    #endif
    #include <windows.h>
#endif

#include <string>

// FFI functions for Flutter
// Export functions for FFI access
#ifdef _WIN32
    #define EXPORT_FUNC __declspec(dllexport)
#else
    #define EXPORT_FUNC
#endif

extern "C" {
    // Create pipe client instance
    EXPORT_FUNC void* createPipeClient(const char* pipeName);
    
    // Connect to named pipe server
    // Returns: 1 = success, 0 = failure
    EXPORT_FUNC int connectPipe(void* client);
    
    // Get last error code (Windows GetLastError)
    EXPORT_FUNC unsigned long getLastError(void* client);
    
    // Send message to server
    EXPORT_FUNC bool sendMessage(void* client, const char* message);
    
    // Receive message from server (non-blocking, returns false if no message)
    EXPORT_FUNC bool receiveMessage(void* client, char* buffer, int bufferSize, int* messageLength);
    
    // Check if connected
    EXPORT_FUNC bool isConnected(void* client);
    
    // Close pipe connection
    EXPORT_FUNC void closePipe(void* client);
}
