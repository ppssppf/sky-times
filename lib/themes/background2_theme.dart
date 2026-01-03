import 'package:flutter/material.dart';
import 'base_theme.dart';

class Background2Theme extends AppTheme {
  @override
  String get id => 'background2';
  
  @override
  String get name => 'Rainy City';
  
  @override
  String get backgroundAsset => 'assets/videos/background2.gif';
  
  // Colores Rainy City - Azules oscuros y amarillos neón
  @override
  Color get primaryNeon => const Color(0xFFFFC800); // Amarillo neón brillante
  
  @override
  Color get secondaryNeon => const Color(0xFF00D9FF); // Cyan azulado
  
  @override
  Color get accentNeon => const Color(0xFFFFE066); // Amarillo cálido
  
  @override
  Color get bgDark1 => const Color(0xFF0A1628); // Azul muy oscuro
  
  @override
  Color get bgDark2 => const Color(0xFF132944); // Azul oscuro medio
  
  @override
  Color get bgDark3 => const Color(0xFF1E3A5F); // Azul medio
  
  @override
  Color get activeColor => const Color(0xFFFFC800);
  
  @override
  Color get inactiveColor => const Color(0xFF1E3A5F);
  
  @override
  Color get nextEventColor => const Color(0xFFFFE066);
  
  @override
  double get overlayOpacityTop => 0.20;
  
  @override
  double get overlayOpacityBottom => 0.35;
  
  // Gradientes
  @override
  LinearGradient get headerGradient => LinearGradient(
    colors: [primaryNeon, accentNeon],
  );
  
  @override
  LinearGradient get clockGradient => LinearGradient(
    colors: [primaryNeon, const Color(0xFFFFD93D)],
  );
  
  @override
  LinearGradient get cardGradientActive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.5),
      bgDark2.withOpacity(0.4),
    ],
  );
  
  @override
  LinearGradient get cardGradientInactive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.25),
      bgDark2.withOpacity(0.15),
    ],
  );
  
  @override
  Gradient get timeRemainingGradient => LinearGradient(
    colors: [accentNeon, primaryNeon],
  );
  
  // Decoraciones
  @override
  BoxDecoration getClockDecoration(double animationValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: primaryNeon.withOpacity(0.6 + animationValue * 0.3),
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
        ? primaryNeon 
        : isEnabled 
            ? secondaryNeon 
            : bgDark3;
    
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor.withOpacity(
          isNext && isEnabled ? 0.7 + animationValue * 0.3 : 0.4
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
                  ? [primaryNeon, accentNeon]
                  : [secondaryNeon, const Color(0xFF00A8CC)],
            )
          : null,
      color: isEnabled ? null : bgDark3,
      boxShadow: getIconShadow(isEnabled, isNext),
    );
  }
  
  @override
  BoxDecoration getNextBadgeDecoration() {
    return BoxDecoration(
      color: primaryNeon,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.6),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  // Sombras - Más intensas para el ambiente lluvioso
  @override
  List<BoxShadow> getClockShadow(double animationValue) {
    return [
      BoxShadow(
        color: primaryNeon.withOpacity(0.4 + animationValue * 0.3),
        blurRadius: 25 + animationValue * 15,
        spreadRadius: 3,
      ),
      BoxShadow(
        color: accentNeon.withOpacity(0.2),
        blurRadius: 15,
        spreadRadius: 1,
      ),
    ];
  }
  
  @override
  List<BoxShadow> getCardShadow(bool isEnabled, bool isNext, double animationValue) {
    if (isNext && isEnabled) {
      return [
        BoxShadow(
          color: primaryNeon.withOpacity(0.4 * animationValue),
          blurRadius: 20,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: accentNeon.withOpacity(0.2 * animationValue),
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
          color: primaryNeon.withOpacity(0.6),
          blurRadius: 12,
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
  Color get switchInactiveTrackColor => Colors.white.withOpacity(0.15);
  
  // Estilos de texto personalizados para mejor contraste
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
    color: secondaryNeon,
    letterSpacing: 1,
  );
}