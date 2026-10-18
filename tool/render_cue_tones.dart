// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

class ToneSpec {
  final String primaryName;
  final List<String> aliases;
  final int semitoneFromA4;

  const ToneSpec({
    required this.primaryName,
    required this.aliases,
    required this.semitoneFromA4,
  });

  double get frequency => 440.0 * pow(2.0, semitoneFromA4 / 12.0);
}

final List<ToneSpec> chromaticTones = [
  ToneSpec(primaryName: 'C4', aliases: ['c4'], semitoneFromA4: -9),
  ToneSpec(
    primaryName: 'Db4',
    aliases: ['C#4', 'db4', 'c#4', 'CSharp4', 'csharp4'],
    semitoneFromA4: -8,
  ),
  ToneSpec(primaryName: 'D4', aliases: ['d4'], semitoneFromA4: -7),
  ToneSpec(
    primaryName: 'Eb4',
    aliases: ['D#4', 'eb4', 'd#4', 'DSharp4', 'dsharp4'],
    semitoneFromA4: -6,
  ),
  ToneSpec(primaryName: 'E4', aliases: ['e4'], semitoneFromA4: -5),
  ToneSpec(primaryName: 'F4', aliases: ['f4'], semitoneFromA4: -4),
  ToneSpec(
    primaryName: 'F#4',
    aliases: ['Gb4', 'f#4', 'gb4', 'FSharp4', 'fsharp4'],
    semitoneFromA4: -3,
  ),
  ToneSpec(primaryName: 'G4', aliases: ['g4'], semitoneFromA4: -2),
  ToneSpec(
    primaryName: 'Ab4',
    aliases: ['G#4', 'ab4', 'g#4', 'GSharp4', 'gsharp4'],
    semitoneFromA4: -1,
  ),
  ToneSpec(primaryName: 'A4', aliases: ['a4'], semitoneFromA4: 0),
  ToneSpec(
    primaryName: 'Bb4',
    aliases: ['A#4', 'bb4', 'a#4', 'ASharp4', 'asharp4'],
    semitoneFromA4: 1,
  ),
  ToneSpec(primaryName: 'B4', aliases: ['b4'], semitoneFromA4: 2),
];

Uint8List generateWav(
  double frequency, {
  int sampleRate = 44100,
  double durationSeconds = 2.0,
}) {
  final totalSamples = (sampleRate * durationSeconds).round();
  final attackSamples = (sampleRate * 0.050).round(); // 50ms attack
  final releaseSamples = (sampleRate * 0.100).round(); // 100ms release
  const maxAmplitude = 26000.0;

  final pcmBytes = BytesBuilder();

  for (int i = 0; i < totalSamples; i++) {
    // Amplitude envelope calculation
    double envelope = 1.0;
    if (i < attackSamples) {
      // Smooth raised-cosine attack ramp
      envelope = 0.5 * (1.0 - cos(pi * i / attackSamples));
    } else if (i >= totalSamples - releaseSamples) {
      // Smooth raised-cosine release ramp
      final releaseIndex = totalSamples - 1 - i;
      envelope = 0.5 * (1.0 - cos(pi * releaseIndex / releaseSamples));
    }

    final t = i / sampleRate;
    final sampleVal = (maxAmplitude * envelope * sin(2.0 * pi * frequency * t))
        .round()
        .clamp(-32768, 32767);
    final bdata = ByteData(2)..setInt16(0, sampleVal, Endian.little);
    pcmBytes.add(bdata.buffer.asUint8List());
  }

  final pcmData = pcmBytes.toBytes();
  final header = BytesBuilder();

  // RIFF header
  header.add([0x52, 0x49, 0x46, 0x46]); // "RIFF"
  final chunkSize = 36 + pcmData.length;
  final bChunkSize = ByteData(4)..setUint32(0, chunkSize, Endian.little);
  header.add(bChunkSize.buffer.asUint8List());
  header.add([0x57, 0x41, 0x56, 0x45]); // "WAVE"

  // "fmt " subchunk
  header.add([0x66, 0x6D, 0x74, 0x20]); // "fmt "
  final bSub1Size = ByteData(4)..setUint32(0, 16, Endian.little);
  header.add(bSub1Size.buffer.asUint8List());
  final bAudioFormat = ByteData(2)..setUint16(0, 1, Endian.little); // PCM
  header.add(bAudioFormat.buffer.asUint8List());
  final bChannels = ByteData(2)..setUint16(0, 1, Endian.little); // 1 channel
  header.add(bChannels.buffer.asUint8List());
  final bSampleRate = ByteData(4)..setUint32(0, sampleRate, Endian.little);
  header.add(bSampleRate.buffer.asUint8List());
  final byteRate = sampleRate * 1 * 2;
  final bByteRate = ByteData(4)..setUint32(0, byteRate, Endian.little);
  header.add(bByteRate.buffer.asUint8List());
  final bBlockAlign = ByteData(2)..setUint16(0, 2, Endian.little);
  header.add(bBlockAlign.buffer.asUint8List());
  final bBitsPerSample = ByteData(2)..setUint16(0, 16, Endian.little);
  header.add(bBitsPerSample.buffer.asUint8List());

  // "data" subchunk
  header.add([0x64, 0x61, 0x74, 0x61]); // "data"
  final bDataSize = ByteData(4)..setUint32(0, pcmData.length, Endian.little);
  header.add(bDataSize.buffer.asUint8List());
  header.add(pcmData);

  return header.toBytes();
}

void main() async {
  final outDir = Directory('assets/audio/cue');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  print('Synthesizing 12 chromatic equal-temperament tonic tones (C4–B4)...');

  // Verify oggenc availability
  final oggencCheck = Process.runSync('which', ['oggenc']);
  final hasOggenc = oggencCheck.exitCode == 0;
  final oggencPath = hasOggenc
      ? (oggencCheck.stdout as String).trim()
      : 'oggenc';

  if (!hasOggenc) {
    print(
      'Warning: oggenc not found on PATH. Attempting fallback or PATH lookup.',
    );
  }

  int generatedCount = 0;

  for (final spec in chromaticTones) {
    final wavBytes = generateWav(spec.frequency);
    final tempWav = File(
      '${Directory.systemTemp.path}/${spec.primaryName}.wav',
    );
    tempWav.writeAsBytesSync(wavBytes);

    final outOgg = File('${outDir.path}/${spec.primaryName}.ogg');

    // Encode to OGG Vorbis
    final res = Process.runSync(oggencPath, [
      '-q',
      '5',
      '-o',
      outOgg.path,
      tempWav.path,
    ]);
    if (res.exitCode != 0) {
      stderr.writeln('Error encoding ${outOgg.path}: ${res.stderr}');
      exit(1);
    }

    if (tempWav.existsSync()) {
      tempWav.deleteSync();
    }

    print(
      '  ✓ Generated ${spec.primaryName}.ogg (${spec.frequency.toStringAsFixed(2)} Hz, ${outOgg.lengthSync()} bytes)',
    );
    generatedCount++;

    // Copy to enharmonic / case aliases so reader lookup always succeeds
    for (final alias in spec.aliases) {
      final aliasFile = File('${outDir.path}/$alias.ogg');
      aliasFile.writeAsBytesSync(outOgg.readAsBytesSync());
    }
  }

  print(
    'Successfully generated $generatedCount chromatic OGG cue tones in ${outDir.path}/',
  );
}
