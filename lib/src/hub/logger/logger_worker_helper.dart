part of '../gaply_hub.dart';

class _AnsiThemeBytes {
  static Uint8List light = GaplyBytesWriter.bytesInt(GaplyAnsiTheme.light.index);
  static Uint8List dark = GaplyBytesWriter.bytesInt(GaplyAnsiTheme.dark.index);

  static Uint8List toBytes(GaplyAnsiTheme theme) {
    return switch (theme) {
      GaplyAnsiTheme.light => light,
      GaplyAnsiTheme.dark => dark,
    };
  }
}

class _OperBytes {
  static Uint8List add = GaplyBytesWriter.bytesInt(_Oper.add.index);
  static Uint8List remove = GaplyBytesWriter.bytesInt(_Oper.remove.index);
  static Uint8List dispose = GaplyBytesWriter.bytesInt(_Oper.dispose.index);
  static Uint8List dispatch = GaplyBytesWriter.bytesInt(_Oper.dispatch.index);
  static Uint8List flush = GaplyBytesWriter.bytesInt(_Oper.flush.index);
  static Uint8List setTheme = GaplyBytesWriter.bytesInt(_Oper.setTheme.index);
  static Uint8List setLevel = GaplyBytesWriter.bytesInt(_Oper.setLevel.index);

  static Uint8List toBytes(_Oper oper) {
    return switch (oper) {
      _Oper.add => add,
      _Oper.remove => remove,
      _Oper.dispose => dispose,
      _Oper.dispatch => dispatch,
      _Oper.flush => flush,
      _Oper.setTheme => setTheme,
      _Oper.setLevel => setLevel,
    };
  }

  static Uint8List toPack(_Oper oper) {
    return switch (oper) {
      _Oper.add => GaplyBytesBuilder.pack([add]),
      _Oper.remove => GaplyBytesBuilder.pack([remove]),
      _Oper.dispose => GaplyBytesBuilder.pack([dispose]),
      _Oper.dispatch => GaplyBytesBuilder.pack([dispatch]),
      _Oper.flush => GaplyBytesBuilder.pack([flush]),
      _Oper.setTheme => GaplyBytesBuilder.pack([setTheme]),
      _Oper.setLevel => GaplyBytesBuilder.pack([setLevel]),
    };
  }
}

class _TypeBytes {
  static Uint8List base = GaplyBytesWriter.bytesInt(_Type.base.index);
  static Uint8List custom = GaplyBytesWriter.bytesInt(_Type.custom.index);

  static Uint8List toBytes(_Type type) {
    return switch (type) {
      _Type.base => base,
      _Type.custom => custom,
    };
  }
}

class _FileModeBytes {
  static Uint8List append = GaplyBytesWriter.bytesInt(_FileMode.append.index);
  static Uint8List overwrite = GaplyBytesWriter.bytesInt(_FileMode.overwrite.index);

  static Uint8List toBytes(_FileMode mode) {
    return switch (mode) {
      _FileMode.append => append,
      _FileMode.overwrite => overwrite,
    };
  }
}

class _SpecTypeBytes {
  static Uint8List console = GaplyBytesWriter.bytesInt(_SpecType.console.index);
  static Uint8List file = GaplyBytesWriter.bytesInt(_SpecType.file.index);
  static Uint8List memory = GaplyBytesWriter.bytesInt(_SpecType.memory.index);

  static Uint8List toBytes(_SpecType type) {
    return switch (type) {
      _SpecType.console => console,
      _SpecType.file => file,
      _SpecType.memory => memory,
    };
  }
}

class _LogLevelBytes {
  static Uint8List debug = GaplyBytesWriter.bytesInt(GaplyLogLevel.debug.index);
  static Uint8List info = GaplyBytesWriter.bytesInt(GaplyLogLevel.info.index);
  static Uint8List warning = GaplyBytesWriter.bytesInt(GaplyLogLevel.warning.index);
  static Uint8List error = GaplyBytesWriter.bytesInt(GaplyLogLevel.error.index);
  static Uint8List none = GaplyBytesWriter.bytesInt(GaplyLogLevel.none.index);

  static Uint8List toBytes(GaplyLogLevel level) {
    return switch (level) {
      GaplyLogLevel.debug => debug,
      GaplyLogLevel.info => info,
      GaplyLogLevel.warning => warning,
      GaplyLogLevel.error => error,
      GaplyLogLevel.none => none,
    };
  }
}

class _OutputModeBytes {
  static Uint8List debugPrint = GaplyBytesWriter.bytesInt(ConsoleOutputMode.debugPrint.index);
  static Uint8List stdout = GaplyBytesWriter.bytesInt(ConsoleOutputMode.stdout.index);

  static Uint8List toBytes(ConsoleOutputMode mode) {
    return switch (mode) {
      ConsoleOutputMode.debugPrint => debugPrint,
      ConsoleOutputMode.stdout => stdout,
    };
  }
}

class _WorkerHelper {
  static Uint8List toSpec(GaplyLoggerSpec logger) {
    GaplyBytesWriter w = GaplyBytesWriter();
    w.writeStringOrNull(logger.id);

    if (logger is GaplyConsoleLoggerSpec) {
      w.addBytes(_SpecTypeBytes.console);
      w.addBytes(_OutputModeBytes.toBytes(logger.outputMode));
      w.writeInt(logger.flushInterval.inMicroseconds);
      w.writeInt(logger.bufferCapacity);
    } else if (logger is GaplyFileLoggerSpec) {
      w.addBytes(_SpecTypeBytes.file);
      w.writeString(logger.path);
      w.writeInt(logger.maxBytes);
      w.addBytes(logger.mode == FileMode.append ? _FileModeBytes.append : _FileModeBytes.overwrite);
      w.writeInt(logger.bufferCapacity);
      w.writeInt(logger.flushInterval.inMicroseconds);
      w.addBytes(_LogLevelBytes.toBytes(logger.minLevel));
    } else if (logger is GaplyMemoryLoggerSpec) {
      w.addBytes(_SpecTypeBytes.memory);
      w.writeInt(logger.maxCapacity);
    }

    return w.takeBytes();
  }

  static GaplyLoggerSpec fromSpec(Uint8List bytes) {
    final r = GaplyBytesReader(bytes);
    final id = r.readStringOrNull();
    final type = _SpecType.values[r.readInt()];

    return switch (type) {
      _SpecType.console => GaplyConsoleLoggerSpec(
        id: id,
        outputMode: r.readInt() == 0 ? ConsoleOutputMode.debugPrint : ConsoleOutputMode.stdout,
        flushInterval: Duration(microseconds: r.readInt()),
        bufferCapacity: r.readInt(),
      ),
      _SpecType.file => GaplyFileLoggerSpec(
        id: id,
        path: r.readString(),
        maxBytes: r.readInt(),
        mode: r.readInt() == _FileMode.append.index ? FileMode.append : FileMode.write,
        bufferCapacity: r.readInt(),
        flushInterval: Duration(microseconds: r.readInt()),
        minLevel: GaplyLogLevel.values[r.readInt()],
      ),
      _SpecType.memory => GaplyMemoryLoggerSpec(id: id, maxCapacity: r.readInt()),
    };
  }
}
