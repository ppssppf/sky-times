import 'package:flutter/material.dart';
import 'base_theme.dart';

class Background6Theme extends AppTheme {
  @override
  String get id => 'background6';
  
  @override
  String get name => 'Dusk Street';
  
  @override
  String get backgroundAsset => 'assets/videos/background6.gif';
  
  // Colores Dusk Street - Naranjas cálidos, rojos oscuros y amarillos
  @override
  Color get primaryNeon => const Color(0xFFFFB830); // Amarillo cálido brillante
  
  @override
  Color get secondaryNeon => const Color(0xFFFF6B3D); // Naranja rojizo
  
  @override
  Color get accentNeon => const Color(0xFFFFC759); // Amarillo dorado
  
  @override
  Color get bgDark1 => const Color(0xFF1F1815); // Marrón muy oscuro
  
  @override
  Color get bgDark2 => const Color(0xFF332A23); // Marrón grisáceo
  
  @override
  Color get bgDark3 => const Color(0xFF4A3F35); // Marrón medio
  
  @override
  Color get activeColor => const Color(0xFFFFB830);
  
  @override
  Color get inactiveColor => const Color(0xFF4A3F35);
  
  @override
  Color get nextEventColor => const Color(0xFFFF6B3D);
  
  @override
  double get overlayOpacityTop => 0.28;
  
  @override
  double get overlayOpacityBottom => 0.45;
  
  // Gradientes
  @override
  LinearGradient get headerGradient => LinearGradient(
    colors: [primaryNeon, secondaryNeon],
  );
  
  @override
  LinearGradient get clockGradient => LinearGradient(
    colors: [primaryNeon, accentNeon],
  );
  
  @override
  LinearGradient get cardGradientActive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.58),
      bgDark2.withOpacity(0.48),
    ],
  );
  
  @override
  LinearGradient get cardGradientInactive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.3),
      bgDark2.withOpacity(0.2),
    ],
  );
  
  @override
  Gradient get timeRemainingGradient => LinearGradient(
    colors: [secondaryNeon, primaryNeon],
  );
  
  // Decoraciones
  @override
  BoxDecoration getClockDecoration(double animationValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: primaryNeon.withOpacity(0.65 + animationValue * 0.3),
        width: 2.5,
      ),
      gradient: LinearGradient(
        colors: [
          bgDark2.withOpacity(0.6),
          bgDark3.withOpacity(0.5),
        ],
      ),
      boxShadow: getClockShadow(animationValue),
    );
  }
  
  @override
  BoxDecoration getCardDecoration(bool isEnabled, bool isNext, double animationValue) {
    final borderColor = isNext && isEnabled 
        ? secondaryNeon 
        : isEnabled 
            ? primaryNeon 
            : bgDark3;
    
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor.withOpacity(
          isNext && isEnabled ? 0.75 + animationValue * 0.25 : 0.45
        ),
        width: isNext ? 2.5 : 2,
      ),
      gradient: isEnabled ? cardGradientActive : cardGradientInactive,
      boxShadow: getCardShadow(isEnabled, isNext, animationValue),
    );
  }
  
  @override
  BoxDecoration getIconDecoration(bool isEnabled, bool isNext) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: isEnabled
          ? LinearGradient(
              colors: isNext 
                  ? [secondaryNeon, primaryNeon]
                  : [primaryNeon, accentNeon],
            )
          : null,
      color: isEnabled ? null : bgDark3,
      boxShadow: getIconShadow(isEnabled, isNext),
    );
  }
  
  @override
  BoxDecoration getNextBadgeDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [secondaryNeon, primaryNeon],
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: secondaryNeon.withOpacity(0.7),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  // Sombras cálidas tipo fogata
  @override
  List<BoxShadow> getClockShadow(double animationValue) {
    return [
      BoxShadow(
        color: primaryNeon.withOpacity(0.42 + animationValue * 0.33),
        blurRadius: 26 + animationValue * 16,
        spreadRadius: 3,
      ),
      BoxShadow(
        color: secondaryNeon.withOpacity(0.25 + animationValue * 0.15),
        blurRadius: 18 + animationValue * 10,
        spreadRadius: 2,
      ),
    ];
  }
  
  @override
  List<BoxShadow> getCardShadow(bool isEnabled, bool isNext, double animationValue) {
    if (isNext && isEnabled) {
      return [
        BoxShadow(
          color: secondaryNeon.withOpacity(0.45 * animationValue),
          blurRadius: 20,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: primaryNeon.withOpacity(0.3 * animationValue),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ];
    }
    return [];
  }
  
  @override
  List<BoxShadow> getIconShadow(bool isEnabled, bool isNext) {
    if (isEnabled && isNext) {
      return [
        BoxShadow(
          color: secondaryNeon.withOpacity(0.65),
          blurRadius: 14,
          spreadRadius: 3,
        ),
      ];
    }
    return [];
  }
  
  // Switch colors
  @override
  Color get switchActiveColor => primaryNeon;
  
  @override
  Color get switchActiveTrackColor => primaryNeon.withOpacity(0.4);
  
  @override
  Color get switchInactiveThumbColor => bgDark3;
  
  @override
  Color get switchInactiveTrackColor => Colors.white.withOpacity(0.16);
  
  // Estilos personalizados
  @override
  TextStyle get clockLabelStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    color: accentNeon,
  );
  
  @override
  TextStyle get eventTimeStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: primaryNeon,
    letterSpacing: 1,
  );
}