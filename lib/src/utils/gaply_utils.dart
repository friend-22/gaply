import 'package:gaply/src/hub/gaply_hub.dart';

class GaplyUtils {
  static bool isValidId(String id) => RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(id);
  static String cleanId(String id) {
    String cleanId = id;
    if (!isValidId(cleanId)) {
      cleanId = cleanId.replaceAll(RegExp(r'[^a-zA-Z0-9_:]'), '_');
      GaplyHub.info('⚠️ [Gaply] Invalid Id "$id" sanitized to "$cleanId"');
    }
    return cleanId;
  }
}
