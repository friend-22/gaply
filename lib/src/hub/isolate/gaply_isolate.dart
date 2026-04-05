import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

part 'gaply_channel.dart';
part 'gaply_worker.dart';

class _Spec {
  static const int headerSize = 8;
  static const int floatSize = 8;
  static const int intSize = 8;
  static const int boolSize = 1;
  static const int stringLenSize = 4;
  static const Duration waitForPendingMessagesTimeout = Duration(seconds: 10);
}

class GaplyBytesBuilder {
  static Uint8List pack(List<Uint8List> payloads) {
    final builder = BytesBuilder(copy: false);
    for (final payload in payloads) {
      final remainder = builder.length % _Spec.headerSize;
      if (remainder != 0) {
        builder.add(Uint8List(8 - remainder));
      }

      final len = ByteData(_Spec.headerSize)..setUint64(0, payload.length);
      builder.add(len.buffer.asUint8List());

      builder.add(payload);
    }
    return builder.takeBytes();
  }

  static List<Uint8List> unpack(Uint8List bytes, {int count = -1}) {
    List<Uint8List> results = [];
    int cursor = 0;
    int found = 0;
    final byteData = ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.length);

    while (cursor + _Spec.headerSize <= bytes.length) {
      if (count != -1 && found >= count) break;

      final int length = byteData.getUint64(cursor);
      cursor += _Spec.headerSize;

      results.add(Uint8List.view(bytes.buffer, bytes.offsetInBytes + cursor, length));

      cursor += length;
      found++;

      final remainder = cursor % _Spec.headerSize;
      if (remainder != 0) cursor += (_Spec.headerSize - remainder);
    }

    if (cursor < bytes.length) {
      final int remainingSize = bytes.length - cursor;

      if (remainingSize >= _Spec.headerSize) {
        final int nextLength = byteData.getUint64(cursor);

        if (_Spec.headerSize + nextLength <= remainingSize) {
          results.add(
            Uint8List.view(bytes.buffer, bytes.offsetInBytes + cursor + _Spec.headerSize, nextLength),
          );
          return results;
        }
      }

      results.add(Uint8List.view(bytes.buffer, bytes.offsetInBytes + cursor, remainingSize));
    }

    return results;
  }
}

class GaplyBytesReader {
  Uint8List _data = Uint8List(0);
  ByteData _view = ByteData(0);
  int _cursor = 0;

  bool get hasNext => _cursor < _data.length;

  GaplyBytesReader([Uint8List? bytes]) {
    if (bytes != null) setSource(bytes);
  }

  void setSource(Uint8List bytes) {
    _data = bytes;
    _view = ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.length);
    _cursor = 0;
  }

  T? readOrNull<T>() {
    if (!readBool()) return null;
    return read<T>();
  }

  T read<T>() {
    if (T == bool) return readBool() as T;
    if (T == int) return readInt() as T;
    if (T == double) return readFloat() as T;
    if (T == String) return readString() as T;
    throw UnsupportedError("Type $T not supported");
  }

  bool readBool() {
    _canRead(_Spec.boolSize);
    final v = _view.getUint8(_cursor);
    _cursor += _Spec.boolSize;
    return v == 1;
  }

  int readInt() {
    _align(_Spec.intSize);
    _canRead(_Spec.intSize);
    final v = _view.getInt64(_cursor);
    _cursor += _Spec.intSize;
    return v;
  }

  double readFloat() {
    _align(_Spec.floatSize);
    _canRead(_Spec.floatSize);
    final v = _view.getFloat64(_cursor);
    _cursor += _Spec.floatSize;
    return v;
  }

  String readString() {
    _align(_Spec.stringLenSize);
    _canRead(_Spec.stringLenSize);

    final length = _view.getUint32(_cursor);
    _cursor += _Spec.stringLenSize;

    _canRead(length);
    final bytes = Uint8List.view(_data.buffer, _data.offsetInBytes + _cursor, length);
    _cursor += length;
    return utf8.decode(bytes);
  }

  T _readTypedList<T extends TypedData>(
    int count,
    int elementSize,
    T Function(ByteBuffer, int, int) viewFactory,
  ) {
    _align(elementSize);
    final totalByteSize = count * elementSize;
    _canRead(totalByteSize);

    final list = viewFactory(_data.buffer, _data.offsetInBytes + _cursor, count);
    _cursor += totalByteSize;
    return list;
  }

  int? readIntOrNull() => readOrNull<int>();
  double? readFloatOrNull() => readOrNull<double>();
  String? readStringOrNull() => readOrNull<String>();
  Int64List readIntList(int count) => _readTypedList(count, _Spec.intSize, Int64List.view);
  Float64List readFloatList(int count) => _readTypedList(count, _Spec.floatSize, Float64List.view);

  void _align(int size) {
    final remainder = _cursor % size;
    if (remainder != 0) _cursor += (size - remainder);
  }

  void _canRead(int size) {
    if (_cursor + size > _data.length) {
      throw RangeError("End of data reached. (Cursor: $_cursor, Request: $size)");
    }
  }
}

class GaplyBytesWriter {
  final BytesBuilder _builder = BytesBuilder(copy: false);
  static final Uint8List _padding = Uint8List(_Spec.headerSize);
  static final ByteData _scratch = ByteData(_Spec.headerSize);
  static final Uint8List _scratchList = _scratch.buffer.asUint8List();

  GaplyBytesWriter([Uint8List? bytes]) {
    if (bytes != null) setSource(bytes);
  }

  void setSource(Uint8List bytes) {
    _builder.add(bytes);
  }

  GaplyBytesWriter writeOrNull<T>(T? value) {
    final bool isNotNull = value != null;
    _builder.addByte(isNotNull ? 1 : 0);
    if (isNotNull) write<T>(value);
    return this;
  }

  GaplyBytesWriter write<T>(T value) {
    if (value is bool) return writeBool(value);
    if (value is int) return writeInt(value);
    if (value is double) return writeFloat(value);
    if (value is String) return writeString(value);
    return this;
  }

  static Uint8List bytesBool(bool value) {
    return Uint8List(1)..[0] = value ? 1 : 0;
  }

  static Uint8List bytesInt(int value) {
    _scratch.setInt64(0, value);
    return Uint8List.fromList(_scratchList);
  }

  static Uint8List bytesFloat(double value) {
    _scratch.setFloat64(0, value);
    return Uint8List.fromList(_scratchList);
  }

  static Uint8List bytesString(String value) {
    final encoded = utf8.encode(value);
    final result = Uint8List(_Spec.stringLenSize + encoded.length);
    final view = ByteData.view(result.buffer);
    view.setUint32(0, encoded.length);
    result.setAll(_Spec.stringLenSize, encoded);
    return result;
  }

  GaplyBytesWriter addBytes(Uint8List bytes, {bool align = true}) {
    if (align) _align(_Spec.headerSize);
    _builder.add(bytes);
    return this;
  }

  GaplyBytesWriter writeInt(int value) {
    _align(_Spec.intSize);
    _scratch.setInt64(0, value);
    _builder.add(Uint8List.sublistView(_scratchList, 0, _Spec.intSize));
    return this;
  }

  GaplyBytesWriter writeFloat(double value) {
    _align(_Spec.floatSize);
    _scratch.setFloat64(0, value);
    _builder.add(Uint8List.sublistView(_scratchList, 0, _Spec.floatSize));
    return this;
  }

  GaplyBytesWriter writeString(String value) {
    _align(_Spec.stringLenSize);
    final encoded = utf8.encode(value);
    final lenBd = ByteData(_Spec.stringLenSize)..setUint32(0, encoded.length);
    _builder.add(lenBd.buffer.asUint8List());
    _builder.add(encoded);
    return this;
  }

  GaplyBytesWriter writeBool(bool value) {
    _builder.addByte(value ? 1 : 0);
    return this;
  }

  GaplyBytesWriter writeList<T extends TypedData>(T list) {
    _align(_Spec.headerSize);
    _builder.add(list.buffer.asUint8List(list.offsetInBytes, list.lengthInBytes));
    return this;
  }

  GaplyBytesWriter writeIntOrNull(int? value) => writeOrNull<int>(value);
  GaplyBytesWriter writeFloatOrNull(double? value) => writeOrNull<double>(value);
  GaplyBytesWriter writeStringOrNull(String? value) => writeOrNull<String>(value);

  Uint8List takeBytes() {
    _align(_Spec.headerSize);
    final bytes = _builder.takeBytes();
    _builder.clear();
    return bytes;
  }

  void _align(int size) {
    final int remainder = _builder.length % size;
    if (remainder != 0) {
      _builder.add(Uint8List.sublistView(_padding, 0, size - remainder));
    }
  }

  int get length => _builder.length;
}
