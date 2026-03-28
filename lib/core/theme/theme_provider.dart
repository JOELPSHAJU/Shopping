import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toggles between [ThemeMode.dark] and [ThemeMode.light].
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
