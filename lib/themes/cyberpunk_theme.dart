import 'package:flutter/material.dart';
import 'base_theme.dart';

class CyberpunkTheme extends AppTheme {
  @override
  String get id => 'cyberpunk';
  
  @override
  String get name => 'Cyberpunk Neon';
  
  @override
  String get backgroundAsset => 'assets/videos/background.gif';
  
  // Colores Cyberpunk
  @override
  Color get primaryNeon => const Color(0xFF00F5FF); // Cyan neón
  
  @override
  Color get secondaryNeon => const Color(0xFF9D4EDD); // Púrpura neón
  
  @override
  Color get accentNeon => const Color(0xFFFF006E); // Rosa neón
  
  @override
  Color get bgDark1 => const Color(0xFF10002B);
  
  @override
  Color get bgDark2 => const Color(0xFF240046);
  
  @override
  Color get bgDark3 => const Color(0xFF3C096C);
  
  @override
  Color get activeColor => const Color(0xFF00F5FF);
  
  @override
  Color get inactiveColor => const Color(0xFF3C096C);
  
  @override
  Color get nextEventColor => const Color(0xFFFF006E);
  
  @override
  double get overlayOpacityTop => 0.15;
  
  @override
  double get overlayOpacityBottom => 0.25;
  
  // Gradientes
  @override
  LinearGradient get headerGradient => LinearGradient(
    colors: [primaryNeon, secondaryNeon],
  );
  
  @override
  LinearGradient get clockGradient => LinearGradient(
    colors: [primaryNeon, const Color(0xFF4CC9F0)],
  );
  
  @override
  LinearGradient get cardGradientActive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.4),
      bgDark2.withOpacity(0.3),
    ],
  );
  
  @override
  LinearGradient get cardGradientInactive => LinearGradient(
    colors: [
      bgDark3.withOpacity(0.2),
      bgDark2.withOpacity(0.1),
    ],
  );
  
  @override
  Gradient get timeRemainingGradient => LinearGradient(
    colors: [accentNeon, secondaryNeon],
  );
  
  // Decoraciones
  @override
  BoxDecoration getClockDecoration(double animationValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: primaryNeon.withOpacity(0.5 + animationValue * 0.3),
        width: 2,
      ),
      gradient: LinearGradient(
        colors: [
          bgDark2.withOpacity(0.4),
          bgDark3.withOpacity(0.3),
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
          isNext && isEnabled ? 0.6 + animationValue * 0.4 : 0.3
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
                  ? [primaryNeon, const Color(0xFF4361EE)]
                  : [secondaryNeon, accentNeon],
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
          color: accentNeon.withOpacity(0.5),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }
  
  // Sombras
  @override
  List<BoxShadow> getClockShadow(double animationValue) {
    return [
      BoxShadow(
        color: primaryNeon.withOpacity(0.3 + animationValue * 0.2),
        blurRadius: 20 + animationValue * 10,
        spreadRadius: 2,
      ),
    ];
  }
  
  @override
  List<BoxShadow> getCardShadow(bool isEnabled, bool isNext, double animationValue) {
    if (isNext && isEnabled) {
      return [
        BoxShadow(
          color: primaryNeon.withOpacity(0.3 * animationValue),
          blurRadius: 15,
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
          blurRadius: 10,
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
  Color get switchActiveTrackColor => primaryNeon.withOpacity(0.3);
  
  @override
  Color get switchInactiveThumbColor => bgDark3;
  
  @override
  Color get switchInactiveTrackColor => Colors.white12;
}