import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_theme.dart';
import 'cyberpunk_theme.dart';
import 'background2_theme.dart';
import 'background3_theme.dart';
import 'background4_theme.dart';
import 'background5_theme.dart';
import 'background6_theme.dart';

class ThemeManager {
  static final ThemeManager instance = ThemeManager._();
  ThemeManager._();

  // Lista de todos los temas disponibles
  final List<AppTheme> _availableThemes = [
    CyberpunkTheme(),
    Background2Theme(),
    Background3Theme(),
    Background4Theme(),
    Background5Theme(),
    Background6Theme(),
  ];

  final ValueNotifier<AppTheme> currentThemeNotifier = ValueNotifier(CyberpunkTheme());

  AppTheme get currentTheme => currentThemeNotifier.value;
  List<AppTheme> get availableThemes => _availableThemes;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeId = prefs.getString('selected_theme') ?? 'cyberpunk';
    
    final theme = _availableThemes.firstWhere(
      (t) => t.id == savedThemeId,
      orElse: () => _availableThemes.first,
    );
    
    currentThemeNotifier.value = theme;
  }

  Future<void> setTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', theme.id);
    currentThemeNotifier.value = theme;
  }

  AppTheme? getThemeById(String id) {
    try {
      return _availableThemes.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}