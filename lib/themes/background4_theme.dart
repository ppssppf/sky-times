import 'package:flutter/material.dart';
import 'base_theme.dart';

class Background4Theme extends AppTheme {
  @override
  String get id => 'background4';
  
  @override
  String get name => 'Night Shop';
  
  @override
  String get backgroundAsset => 'assets/videos/background4.gif';
  
  // Colores Night Shop - Rojos cálidos y azules fríos con toques de neón
  @override
  Color get primaryNeon => const Color(0xFFFF4757); // Rojo coral brillante
  
  @override
  Color get secondaryNeon => const Color(0xFF5DADE2); // Azul cielo claro
  
  @override
  Color get accentNeon => const Color(0xFFFF6B81); // Rosa coral
  
  @override
  Color get bgDark1 => const Color(0xFF1C1C2E); // Gris azulado muy oscuro
  
  @override
  Color get bgDark2 => const Color(0xFF2C2C3E); // Gris azulado oscuro
  
  @override
  Color get bgDark3 => const Color(0xFF3D3D52); // Gris azulado medio
  
  @override
  Color get activeColor => const Color(0xFFFF4757);
  
  @override
  Color get inactiveColor => const Color(0xFF3D3D52);
  
  @override
  Color get nextEventColor => const Color(0xFFFF6B81);
  
  @override
  double get overlayOpacityTop => 0.22;
  
  @override
  double get overlayOpacityBottom => 0.38;
  
  // Gradientes
  @override
  LinearGradient get headerGradient => LinearGradient(
    colors: [primaryNeon, accentNeon],
  );
  
  @override
  LinearGradient get clockGradient => LinearGradient(
    colors: [secondaryNeon, const Color(0xFF74B9FF)],
  );
  
  @override
  LinearGradient get cardGradientActive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.55),
      bgDark2.withOpacity(0.45),
    ],
  );
  
  @override
  LinearGradient get cardGradientInactive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.28),
      bgDark2.withOpacity(0.18),
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
        color: secondaryNeon.withOpacity(0.65 + animationValue * 0.25),
        width: 2.5,
      ),
      gradient: LinearGradient(
        colors: [
          bgDark2.withOpacity(0.55),
          bgDark3.withOpacity(0.45),
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
                  ? [primaryNeon, accentNeon]
                  : [secondaryNeon, const Color(0xFF74B9FF)],
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
          color: primaryNeon.withOpacity(0.65),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  // Sombras con mezcla de rojos y azules
  @override
  List<BoxShadow> getClockShadow(double animationValue) {
    return [
      BoxShadow(
        color: secondaryNeon.withOpacity(0.38 + animationValue * 0.27),
        blurRadius: 24 + animationValue * 14,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: primaryNeon.withOpacity(0.15),
        blurRadius: 12,
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
          blurRadius: 18,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: secondaryNeon.withOpacity(0.2 * animationValue),
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
          blurRadius: 13,
          spreadRadius: 2,
        ),
      ];
    }
    return [];
  }
  
  // Switch colors
  @override
  Color get switchActiveColor => primaryNeon;
  
  @override
  Color get switchActiveTrackColor => primaryNeon.withOpacity(0.38);
  
  @override
  Color get switchInactiveThumbColor => bgDark3;
  
  @override
  Color get switchInactiveTrackColor => Colors.white.withOpacity(0.14);
  
  // Estilos personalizados
  @override
  TextStyle get clockLabelStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    color: accentNeon,
  );
}