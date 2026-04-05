part of 'gaply_isolate.dart';

class GaplyChannelPool {
  static final Map<String, GaplyChannel> _channels = {};

  static GaplyChannel getChannel(String id) {
    if (_channels.containsKey(id)) {
      return _channels[id]!;
    }
    final channel = GaplyChannel(id: id);
    _channels[id] = channel;
    return channel;
  }

  static Future<void> removeChannel(String id) async {
    if (!_channels.containsKey(id)) return;

    await _channels[id]?._onDisposeRequest();
    _channels.remove(id);
  }

  static bool isReady(String id) {
    if (!_channels.containsKey(id)) return false;
    return _channels[id]!.isReady;
  }

  static bool isAllReady() => _channels.values.every((w) => w.isReady);

  static Future<void> waitUntilAllReady() async {
    final futures = _channels.values.map((c) => c.onReady);
    await Future.wait(futures);
  }

  static String get keys => _channels.keys.join(', ');

  static Future<void> dispose() async {
    await Future.wait(_channels.values.map((c) => c._onDisposeRequest()));
    _channels.clear();
  }
}

class GaplyChannel {
  static const String systemPing = 'gaply_sync_ping';
  static const String systemPong = 'gaply_sync_pong';

  final String id;

  final ReceivePort _receivePort = ReceivePort();
  final Map<String, Function(dynamic)> _listeners = {};

  final Completer<void> _readyCompleter = Completer<void>();
  bool _isReady = false;
  bool get isReady => _isReady;
  Future<void> get onReady => _readyCompleter.future;

  GaplyChannel({required this.id}) {
    _receivePort.listen(_handleIncomingData);
    _isReady = true;
    _readyCompleter.complete();
  }

  void _handleIncomingData(dynamic data) {
    if (data is Uint8List) {
      final items = GaplyBytesBuilder.unpack(data, count: 1);
      final id = GaplyBytesReader(items[0]).readString();
      _listeners[id]?.call(items[1]);
    } else if (data is List && data.length >= 2) {
      final String id = data[0];
      final dynamic payload = data[1];

      if (id == systemPing) {
        final SendPort replyPort = payload;
        replyPort.send(systemPong);
      }
    }
  }

  Future<void> waitForPendingMessages() async {
    final responsePort = ReceivePort();
    _receivePort.sendPort.send([systemPing, responsePort.sendPort]);

    await responsePort.first.timeout(_Spec.waitForPendingMessagesTimeout, onTimeout: () => systemPong);
    responsePort.close();
  }

  int _listenerCounter = 0;
  String registerListener(Function(dynamic) listener) {
    final String newId = 'L_${_listenerCounter++}_${DateTime.now().microsecondsSinceEpoch}';
    _listeners[newId] = listener;
    return newId;
  }

  void removeListener(String id) => _listeners.remove(id);

  void sendPacket(String id, Uint8List payload) {
    final w = GaplyBytesWriter().writeString(id);
    final header = w.takeBytes();
    final packet = GaplyBytesBuilder.pack([header, payload]);
    _receivePort.sendPort.send(packet);
  }

  Future<void> dispose() async {
    if (!_isReady) return;

    await GaplyChannelPool.removeChannel(id);
  }

  Future<void> _onDisposeRequest() async {
    await waitForPendingMessages();
    _receivePort.close();
    _listeners.clear();
    _isReady = false;
  }
}
