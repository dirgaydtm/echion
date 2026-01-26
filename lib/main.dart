import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(authBoxName);
  await Hive.openBox(songsBoxName);
  final box = Hive.box(authBoxName);
  if (!box.containsKey(themeModeKey)) {
    box.put(themeModeKey, 'dark');
  }

  runApp(const ProviderScope(child: EchionApp()));
}
