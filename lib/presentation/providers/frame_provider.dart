import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/frame/layout_frame.dart';
import '../../data/services/layout_frame_service.dart';

final layoutFrameServiceProvider = Provider<LayoutFrameService>((_) {
  return LayoutFrameService();
});

final availableFramesProvider = FutureProvider<List<LayoutFrame>>((ref) async {
  final service = ref.watch(layoutFrameServiceProvider);
  await service.ensureCustomDirectory();
  return service.scanFrames();
});
