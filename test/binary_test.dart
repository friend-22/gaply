import 'dart:typed_data';
import 'package:gaply/src/hub/isolate/gaply_isolate.dart';

void main() {
  print('--- Gaply Binary Engine Test Start ---');

  // 1. 기능 및 무결성 테스트
  testIntegrity();

  // 2. 성능 벤치마크 (Warm-up 포함)
  benchmarkPerformance();
}

/// [1] 데이터 무결성 테스트: 쓴 대로 읽히는지, 계층이 유지되는지 확인
void testIntegrity() {
  final writer = GaplyBytesWriter();

  // 데이터 준비
  writer.writeBool(true);
  writer.writeFloat(98.5);
  writer.writeString("Gaply");
  writer.writeInt(12345);
  final fList = Float64List.fromList([1.0, 2.0, 3.0]);
  writer.writeList(fList);

  final payload = writer.takeBytes();

  writer.writeString("GaplyHeader");
  final header = writer.takeBytes();

  // 패킹 (계층화)
  final packed = GaplyBytesBuilder.pack([header, payload]);
  print('Packed Size: ${packed.length} bytes');

  // 언팩 및 검증
  final step1 = GaplyBytesBuilder.unpack(packed, count: 1);
  if (step1.length != 2) throw Exception("Unpack count mismatch");

  final reader = GaplyBytesReader();

  // 헤더 검증
  reader.setSource(step1[0]);
  final decodedHeader = reader.readString();
  assert(decodedHeader == "GaplyHeader");
  print('Header Check: $decodedHeader (OK)');

  // 바디(페이로드) 검증
  reader.setSource(step1[1]);
  assert(reader.readBool() == true);
  assert(reader.readFloat() == 98.5);
  assert(reader.readString() == "Gaply");
  assert(reader.readInt() == 12345);

  final readList = reader.readFloatList(3);
  assert(readList[0] == 1.0 && readList[2] == 3.0);
  print('Payload Check: All Data Matched (OK)');
}

/// [2] 성능 벤치마크: 실제 처리 속도 측정
void benchmarkPerformance() {
  const int iterations = 10000000;

  // Warm-up: JIT 컴파일러가 코드를 최적화할 시간을 줌
  for (int i = 0; i < 1000; i++) {
    _runSingleFlow();
  }

  final watch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    _runSingleFlow();
  }

  watch.stop();

  final totalMs = watch.elapsedMilliseconds;
  final avgUs = (watch.elapsedMicroseconds / iterations).toStringAsFixed(2);

  print('--- Benchmark Result ---');
  print('Total Iterations: $iterations');
  print('Total Time: ${totalMs}ms');
  print('Average per Run: ${avgUs}μs (마이크로초)');
  print('------------------------');
}

/// 테스트용 단일 실행 흐름
void _runSingleFlow() {
  final writer = GaplyBytesWriter();
  writer.writeBool(true);
  writer.writeFloat(1.2345);
  writer.writeString("Bench");
  final p = writer.takeBytes();

  final hWriter = GaplyBytesWriter();
  hWriter.writeString("H");
  final h = hWriter.takeBytes();

  final packed = GaplyBytesBuilder.pack([h, p]);
  final uncurried = GaplyBytesBuilder.unpack(packed, count: 1);

  final reader = GaplyBytesReader();
  reader.setSource(uncurried[0]);
  reader.readString();

  reader.setSource(uncurried[1]);
  reader.readBool();
  reader.readFloat();
  reader.readString();
}
