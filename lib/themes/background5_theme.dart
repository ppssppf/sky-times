import 'package:flutter/material.dart';
import 'base_theme.dart';

class Background5Theme extends AppTheme {
  @override
  String get id => 'background5';
  
  @override
  String get name => 'Sunset Dreams';
  
  @override
  String get backgroundAsset => 'assets/videos/background5.gif';
  
  // Colores Sunset Dreams - Rosas, naranjas y turquesas
  @override
  Color get primaryNeon => const Color(0xFFFF6B9D); // Rosa vibrante
  
  @override
  Color get secondaryNeon => const Color(0xFFFFA07A); // Naranja suave
  
  @override
  Color get accentNeon => const Color(0xFF20E3B2); // Turquesa brillante
  
  @override
  Color get bgDark1 => const Color(0xFF1A1625); // Púrpura muy oscuro
  
  @override
  Color get bgDark2 => const Color(0xFF2A2438); // Púrpura grisáceo
  
  @override
  Color get bgDark3 => const Color(0xFF3D3450); // Gris púrpura
  
  @override
  Color get activeColor => const Color(0xFFFF6B9D);
  
  @override
  Color get inactiveColor => const Color(0xFF3D3450);
  
  @override
  Color get nextEventColor => const Color(0xFF20E3B2);
  
  @override
  double get overlayOpacityTop => 0.18;
  
  @override
  double get overlayOpacityBottom => 0.32;
  
  // Gradientes
  @override
  LinearGradient get headerGradient => LinearGradient(
    colors: [primaryNeon, secondaryNeon, accentNeon],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  @override
  LinearGradient get clockGradient => LinearGradient(
    colors: [primaryNeon, secondaryNeon],
  );
  
  @override
  LinearGradient get cardGradientActive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.48),
      bgDark2.withOpacity(0.38),
    ],
  );
  
  @override
  LinearGradient get cardGradientInactive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.22),
      bgDark2.withOpacity(0.12),
    ],
  );
  
  @override
  Gradient get timeRemainingGradient => LinearGradient(
    colors: [accentNeon, primaryNeon, secondaryNeon],
  );
  
  // Decoraciones
  @override
  BoxDecoration getClockDecoration(double animationValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: primaryNeon.withOpacity(0.55 + animationValue * 0.35),
        width: 2,
      ),
      gradient: LinearGradient(
        colors: [
          bgDark2.withOpacity(0.5),
          bgDark3.withOpacity(0.4),
        ],
      ),
      boxShadow: getClockShadow(animationValue),
    );
  }
  
  @override
  BoxDecoration getCardDecoration(bool isEnabled, bool isNext, double animationValue) {
    final borderColor = isNext && isEnabled 
        ? accentNeon 
        : isEnabled 
            ? primaryNeon 
            : bgDark3;
    
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor.withOpacity(
          isNext && isEnabled ? 0.7 + animationValue * 0.3 : 0.4
        ),
        width: isNext ? 2 : 1.5,
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
                  ? [accentNeon, primaryNeon]
                  : [primaryNeon, secondaryNeon],
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
        colors: [accentNeon, primaryNeon],
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: accentNeon.withOpacity(0.6),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  // Sombras cálidas y vibrantes
  @override
  List<BoxShadow> getClockShadow(double animationValue) {
    return [
      BoxShadow(
        color: primaryNeon.withOpacity(0.32 + animationValue * 0.28),
        blurRadius: 20 + animationValue * 12,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: accentNeon.withOpacity(0.18 + animationValue * 0.12),
        blurRadius: 14 + animationValue * 8,
        spreadRadius: 1,
      ),
    ];
  }
  
  @override
  List<BoxShadow> getCardShadow(bool isEnabled, bool isNext, double animationValue) {
    if (isNext && isEnabled) {
      return [
        BoxShadow(
          color: accentNeon.withOpacity(0.38 * animationValue),
          blurRadius: 16,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: primaryNeon.withOpacity(0.22 * animationValue),
          blurRadius: 10,
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
          color: accentNeon.withOpacity(0.6),
          blurRadius: 14,
          spreadRadius: 3,
        ),
      ];
    }
    return [];
  }
  
  // Switch colors
  @override
  Color get switchActiveColor => accentNeon;
  
  @override
  Color get switchActiveTrackColor => accentNeon.withOpacity(0.35);
  
  @override
  Color get switchInactiveThumbColor => bgDark3;
  
  @override
  Color get switchInactiveTrackColor => Colors.white.withOpacity(0.13);
  
  // Estilos personalizados
  @override
  TextStyle get clockLabelStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    color: secondaryNeon,
  );
  
  @override
  TextStyle get eventTimeStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: accentNeon,
    letterSpacing: 1,
  );
}