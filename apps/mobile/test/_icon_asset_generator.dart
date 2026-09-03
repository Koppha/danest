// Dev tool, not a real test — regenerates the app icon source images from
// the actual in-app mark (see login_screen.dart / app_shell.dart —
// DnColors.navySoft box + Icons.local_car_wash) whenever that mark changes.
// Named with a leading underscore so `flutter test`'s default *_test.dart
// glob skips it; run it explicitly:
//   flutter test test/_icon_asset_generator.dart
//   dart run flutter_launcher_icons
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:de_nest/design_system/theme.dart';

// flutter_test replaces every font (including the bundled MaterialIcons)
// with a placeholder "tofu" glyph by default, so Icon() renders as a plain
// box unless the real font is loaded explicitly under the same family name.
// The font ships inside the Flutter SDK itself (not this repo), so its
// location is derived from the running SDK rather than a hardcoded path.
Future<void> _loadRealMaterialIconsFont() async {
  final parts = p.split(Platform.resolvedExecutable);
  final cacheIndex = parts.indexOf('cache');
  final flutterRoot = p.joinAll(parts.sublist(0, cacheIndex - 1));
  final fontPath = p.join(flutterRoot, 'bin', 'cache', 'artifacts', 'material_fonts', 'materialicons-regular.otf');
  final bytes = await File(fontPath).readAsBytes();
  final loader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

Future<void> _capture(WidgetTester tester, GlobalKey key, String path) async {
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await File(path).create(recursive: true);
    await File(path).writeAsBytes(byteData!.buffer.asUint8List());
  });
}

void main() {
  const canvas = 1024.0;

  testWidgets('generate app icon source images from the in-app mark', (tester) async {
    await tester.runAsync(_loadRealMaterialIconsFont);
    tester.view.physicalSize = const Size(canvas, canvas);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final fullKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: RepaintBoundary(
            key: fullKey,
            child: Container(
              width: canvas,
              height: canvas,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: DnColors.navySoft, borderRadius: BorderRadius.circular(canvas * 14 / 56)),
              child: const Icon(Icons.local_car_wash, color: Colors.white, size: canvas * 28 / 56),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _capture(tester, fullKey, 'build/icon_src/icon_full.png');

    final fgKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: RepaintBoundary(
            key: fgKey,
            child: const SizedBox(
              width: canvas,
              height: canvas,
              child: Center(child: Icon(Icons.local_car_wash, color: Colors.white, size: canvas * 0.55)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _capture(tester, fgKey, 'build/icon_src/icon_foreground.png');
  });
}
