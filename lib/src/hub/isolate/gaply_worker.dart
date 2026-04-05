part of 'gaply_isolate.dart';

class GaplyWorkerPool {
  static final Map<String, GaplyWorker> _workers = {};

  static GaplyWorker getWorker(
    String id,
    void Function(SendPort) entryPoint,
    void Function(Uint8List bytes) listener,
  ) {
    if (_workers.containsKey(id)) {
      return _workers[id]!;
    }
    final worker = GaplyWorker(id: id, entryPoint: entryPoint, listener: listener);
    _workers[id] = worker;
    return worker;
  }

  static Future<void> removeWorker(String id) async {
    if (!_workers.containsKey(id)) return;

    await _workers[id]?._onDisposeRequest();
    _workers.remove(id);
  }

  static bool isReady(String id) {
    if (!_workers.containsKey(id)) return false;
    return _workers[id]!.isReady;
  }

  static bool isAllReady() => _workers.values.every((w) => w.isReady);

  static Future<void> waitUntilAllReady() async {
    final futures = _workers.values.map((w) => w.onReady);
    await Future.wait(futures);
  }

  static String get keys => _workers.keys.join(', ');

  static Future<void> dispose() async {
    await Future.wait(_workers.values.map((w) => w._onDisposeRequest()));
    _workers.clear();
  }
}

class GaplyWorker {
  static const String systemPing = 'gaply_sync_ping';
  static const String systemPong = 'gaply_sync_pong';

  final String id;
  final void Function(Uint8List bytes) listener;

  Isolate? _profilerIsolate;
  SendPort? _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  final ListQueue<Uint8List> _buffer = ListQueue();

  final Completer<void> _readyCompleter = Completer<void>();
  bool _isReady = false;
  bool get isReady => _isReady;
  Future<void> get onReady => _readyCompleter.future;

  GaplyWorker({required this.id, required void Function(SendPort) entryPoint, required this.listener}) {
    _prepare(entryPoint);
  }

  Future<void> _prepare(void Function(SendPort) entryPoint) async {
    _profilerIsolate = await Isolate.spawn(entryPoint, _receivePort.sendPort, debugName: id);

    _receivePort.listen((data) {
      if (data is SendPort) {
        _sendPort = data;
        _isReady = true;
        if (!_readyCompleter.isCompleted) _readyCompleter.complete();
        _flushBuffer();
      } else if (data is Uint8List) {
        listener(data);
      } else if (data is List && data.length >= 2) {
        final String sysId = data[0];
        final dynamic payload = data[1];

        if (sysId == systemPing && payload is SendPort) {
          payload.send(systemPong);
        }
      }
    });
  }

  void _flushBuffer() {
    if (_buffer.isEmpty) return;

    final packetsToFlush = List<Uint8List>.from(_buffer);
    _buffer.clear();

    if (packetsToFlush.isNotEmpty) {
      for (var packet in packetsToFlush) {
        _sendPort!.send(packet);
      }
    }
  }

  Future<void> waitForPendingMessages() async {
    if (_sendPort == null) return;

    final responsePort = ReceivePort();
    _sendPort!.send([systemPing, responsePort.sendPort]);

    await responsePort.first.timeout(_Spec.waitForPendingMessagesTimeout, onTimeout: () => systemPong);
    responsePort.close();
  }

  void sendPacket(Uint8List bytes) {
    if (_sendPort == null) {
      if (_buffer.length >= 500) {
        _buffer.removeFirst();
      }

      _buffer.add(bytes);
      return;
    }
    _sendPort!.send(bytes);
  }

  Future<void> dispose() async {
    if (_profilerIsolate == null) return;

    await GaplyWorkerPool.removeWorker(id);
  }

  Future<void> _onDisposeRequest() async {
    await waitForPendingMessages();

    if (_sendPort != null) {
      _profilerIsolate?.kill(priority: Isolate.beforeNextEvent);
    } else {
      _profilerIsolate?.kill(priority: Isolate.immediate);
    }

    _receivePort.close();
    _profilerIsolate = null;
    _sendPort = null;
    _buffer.clear();
    _isReady = false;
  }
}

// void workerEntryPoint(SendPort mainSendPort) {
//   ReceivePort workerReceivePort = ReceivePort();
//   mainSendPort.send(workerReceivePort.sendPort);
//
//   workerReceivePort.listen((data) {
//     if (data is List && data.length >= 2) {
//       final String id = data[0];
//       final dynamic payload = data[1];
//
//       final worker = GaplyWorkerPool.getWorker(id);
//       worker.listener(payload);
//     }
//
//     // 2. 워커가 데이터를 가공함 (예: 프로파일링 계산)
//     String processedData = "Processed: $data";
//
//     // 3. 다시 메인으로 결과 전송! (전달받은 mainSendPort 사용)
//     mainSendPort.send(processedData);
//   });
// }
