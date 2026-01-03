import 'package:flutter/material.dart';
import 'base_theme.dart';

class Background3Theme extends AppTheme {
  @override
  String get id => 'background3';
  
  @override
  String get name => 'Purple City';
  
  @override
  String get backgroundAsset => 'assets/videos/background3.gif';
  
  // Colores Purple City - Púrpuras profundos y azules eléctricos
  @override
  Color get primaryNeon => const Color(0xFF6B5EFF); // Púrpura brillante
  
  @override
  Color get secondaryNeon => const Color(0xFF4A90E2); // Azul cielo
  
  @override
  Color get accentNeon => const Color(0xFFB794F6); // Lavanda brillante
  
  @override
  Color get bgDark1 => const Color(0xFF1A0B2E); // Púrpura muy oscuro
  
  @override
  Color get bgDark2 => const Color(0xFF2D1B4E); // Púrpura oscuro
  
  @override
  Color get bgDark3 => const Color(0xFF4A2F7C); // Púrpura medio
  
  @override
  Color get activeColor => const Color(0xFF6B5EFF);
  
  @override
  Color get inactiveColor => const Color(0xFF4A2F7C);
  
  @override
  Color get nextEventColor => const Color(0xFFB794F6);
  
  @override
  double get overlayOpacityTop => 0.25;
  
  @override
  double get overlayOpacityBottom => 0.40;
  
  // Gradientes
  @override
  LinearGradient get headerGradient => LinearGradient(
    colors: [primaryNeon, accentNeon],
  );
  
  @override
  LinearGradient get clockGradient => LinearGradient(
    colors: [primaryNeon, secondaryNeon],
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
                  ? [primaryNeon, accentNeon]
                  : [secondaryNeon, const Color(0xFF5B9FE3)],
            )
          : null,
      color: isEnabled ? null : bgDark3,
      boxShadow: getIconShadow(isEnabled, isNext),
    );
  }
  
  @override
  BoxDecoration getNextBadgeDecoration() {
    return BoxDecoration(
      color: accentNeon,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: accentNeon.withOpacity(0.6),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  // Sombras suaves púrpuras
  @override
  List<BoxShadow> getClockShadow(double animationValue) {
    return [
      BoxShadow(
        color: primaryNeon.withOpacity(0.35 + animationValue * 0.25),
        blurRadius: 22 + animationValue * 12,
        spreadRadius: 2,
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
          color: primaryNeon.withOpacity(0.35 * animationValue),
          blurRadius: 18,
          spreadRadius: 2,
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
          color: primaryNeon.withOpacity(0.5),
          blurRadius: 12,
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
  Color get switchActiveTrackColor => primaryNeon.withOpacity(0.35);
  
  @override
  Color get switchInactiveThumbColor => bgDark3;
  
  @override
  Color get switchInactiveTrackColor => Colors.white.withOpacity(0.12);
}