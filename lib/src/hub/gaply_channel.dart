part of 'gaply_hub.dart';

class GaplyChannelPool {
  static final Map<String, GaplyChannel> _channels = {};

  static GaplyChannel getChannel(String id) {
    if (_channels.containsKey(id)) {
      return _channels[id]!;
    }
    final channel = GaplyChannel();
    _channels[id] = channel;
    return channel;
  }

  static void removeChannel(String id) {
    if (!_channels.containsKey(id)) return;

    _channels[id]?.dispose();
    _channels.remove(id);
  }

  static String get keys => _channels.keys.join(', ');

  static void dispose() {
    for (var channel in _channels.values) {
      channel.dispose();
    }
    _channels.clear();
  }
}

class GaplyChannel {
  final ReceivePort _receivePort = ReceivePort();
  final Map<String, Function(dynamic)> _listeners = {};

  GaplyChannel() {
    _receivePort.listen((data) {
      if (data is List && data.length >= 2) {
        final String id = data[0];
        final dynamic payload = data[1];
        _listeners[id]?.call(payload);
      }
    });
  }

  String registerListener(String id, Function(dynamic) listener) {
    final String cleanId = GaplyUtils.cleanId(id);
    final String newId = '${cleanId}_${DateTime.now().microsecondsSinceEpoch}';
    _listeners[newId] = listener;
    return newId;
  }

  void removeListener(String id) => _listeners.remove(id);

  SendPort get sendPort => _receivePort.sendPort;

  void dispose() => _receivePort.close();
}

extension GaplySendX on SendPort {
  void sendPacket(String id, dynamic payload) {
    send([id, payload]);
  }
}
