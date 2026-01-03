import 'package:flutter/material.dart';

/// Clase base abstracta que define la estructura de un tema
abstract class AppTheme {
  // Identificación del tema
  String get id;
  String get name;
  String get backgroundAsset;
  
  // Colores principales
  Color get primaryNeon;
  Color get secondaryNeon;
  Color get accentNeon;
  
  // Colores de fondo
  Color get bgDark1;
  Color get bgDark2;
  Color get bgDark3;
  
  // Colores para estados
  Color get activeColor;
  Color get inactiveColor;
  Color get nextEventColor;
  
  // Opacidad del overlay sobre el GIF
  double get overlayOpacityTop;
  double get overlayOpacityBottom;
  
  // Estilos de texto
  TextStyle get headerTextStyle => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 3,
    color: Colors.white,
  );
  
  TextStyle get clockLabelStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: primaryNeon.withOpacity(0.9),
  );
  
  TextStyle get clockTimeStyle => const TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontFamily: 'monospace',
    letterSpacing: 2,
  );
  
  TextStyle get eventTitleStyle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    letterSpacing: 1,
    color: Colors.white,
  );
  
  TextStyle get eventTimeStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: accentNeon,
    letterSpacing: 1,
  );
  
  // Gradientes
  LinearGradient get headerGradient;
  LinearGradient get clockGradient;
  LinearGradient get cardGradientActive;
  LinearGradient get cardGradientInactive;
  Gradient get timeRemainingGradient;
  
  // Decoraciones y efectos
  BoxDecoration getClockDecoration(double animationValue);
  BoxDecoration getCardDecoration(bool isEnabled, bool isNext, double animationValue);
  BoxDecoration getIconDecoration(bool isEnabled, bool isNext);
  BoxDecoration getNextBadgeDecoration();
  
  // Sombras (glow effects)
  List<BoxShadow> getClockShadow(double animationValue);
  List<BoxShadow> getCardShadow(bool isEnabled, bool isNext, double animationValue);
  List<BoxShadow> getIconShadow(bool isEnabled, bool isNext);
  
  // Colores del Switch
  Color get switchActiveColor;
  Color get switchActiveTrackColor;
  Color get switchInactiveThumbColor;
  Color get switchInactiveTrackColor;
}