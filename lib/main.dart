import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'themes/theme_manager.dart';
import 'themes/base_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Los_Angeles'));
  await NotificationService.instance.initialize();
  await AudioService.instance.initialize();
  await ThemeManager.instance.initialize();
  
  runApp(const MyApp());
}

// 🎵 Servicio de Audio Optimizado con Precarga
class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final AudioPlayer _introPlayer = AudioPlayer();
  final AudioPlayer _togglePlayer = AudioPlayer();
  bool _initialized = false;
  bool _hasVibrator = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _togglePlayer.setReleaseMode(ReleaseMode.stop);
    await _togglePlayer.setPlayerMode(PlayerMode.lowLatency);
    
    _hasVibrator = await Vibration.hasVibrator() ?? false;
    
    _initialized = true;
  }

  Future<void> playIntro() async {
    try {
      await _introPlayer.play(AssetSource('sounds/intro.wav'));
    } catch (e) {
      debugPrint('Error intro: $e');
    }
  }

  Future<void> stopIntro() async {
    try {
      await _introPlayer.stop();
    } catch (e) {
      debugPrint('Error stop intro: $e');
    }
  }

  Future<void> playToggle(bool isActivating) async {
    try {
      await _togglePlayer.stop();
      await _togglePlayer.play(
        AssetSource(isActivating ? 'sounds/activate.wav' : 'sounds/deactivate.wav'),
      );
      
      if (_hasVibrator) {
        if (isActivating) {
          await Vibration.vibrate(duration: 50, amplitude: 128);
        } else {
          await Vibration.vibrate(duration: 30, amplitude: 64);
          await Future.delayed(const Duration(milliseconds: 60));
          await Vibration.vibrate(duration: 30, amplitude: 64);
        }
      }
    } catch (e) {
      debugPrint('Error toggle: $e');
    }
  }

  void dispose() {
    _introPlayer.dispose();
    _togglePlayer.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: ThemeManager.instance.currentThemeNotifier,
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Sky Times',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// 🌟 Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  
  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    AudioService.instance.playIntro();
    
    await Future.delayed(const Duration(seconds: 4));
    
    if (mounted) {
      await AudioService.instance.stopIntro();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.instance.currentTheme;
    
    return Scaffold(
      backgroundColor: theme.bgDark1,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [
                  theme.primaryNeon.withOpacity(0.2),
                  theme.bgDark1,
                  theme.bgDark2,
                ],
              ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    final glowIntensity = 0.4 + (_glowController.value * 0.6);
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryNeon.withOpacity(glowIntensity),
                            blurRadius: 60 + _glowController.value * 40,
                            spreadRadius: 20 + _glowController.value * 20,
                          ),
                          BoxShadow(
                            color: theme.accentNeon.withOpacity(glowIntensity * 0.7),
                            blurRadius: 40 + _glowController.value * 30,
                            spreadRadius: 10 + _glowController.value * 15,
                          ),
                        ],
                      ),
                      child: Opacity(
                        opacity: glowIntensity,
                        child: const Text('✨', style: TextStyle(fontSize: 120)),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 50),
                
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            theme.primaryNeon,
                            theme.secondaryNeon,
                            theme.accentNeon,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'SKY TIMES',
                          style: theme.headerTextStyle.copyWith(fontSize: 48, letterSpacing: 4),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 30),
                
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Column(
                      children: [
                        Text(
                          'CARGANDO...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: theme.primaryNeon.withOpacity(0.7 + _glowController.value * 0.3),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: null,
                              backgroundColor: theme.bgDark3,
                              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryNeon),
                              minHeight: 8,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🌙 Fondo GIF Dinámico - Reactivo a cambios de tema
class DynamicBackground extends StatelessWidget {
  const DynamicBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: ThemeManager.instance.currentThemeNotifier,
      builder: (context, theme, child) {
        return Stack(
          key: ValueKey(theme.id),
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    theme.backgroundAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.bgDark1,
                              theme.bgDark2,
                              theme.bgDark3,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.bgDark1.withOpacity(theme.overlayOpacityTop),
                      Colors.transparent,
                      theme.bgDark1.withOpacity(theme.overlayOpacityBottom),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Timer _timer;
  DateTime _currentPSTTime = DateTime.now();
  late AnimationController _pulseController;
  late AnimationController _glowController;
  bool _isCalculating = true;
  
  static const Map<String, List<String>> eventosPST = {
    'abuela': ['00:35', '02:35', '04:35', '06:35', '08:35', '10:35', '12:35', '14:35', '16:35', '18:35', '20:35', '22:35'],
    'tortuga': ['00:50', '02:50', '04:50', '06:50', '08:50', '10:50', '12:50', '14:50', '16:50', '18:50', '20:50', '22:50'],
    'geyser': ['00:05', '02:05', '04:05', '06:05', '08:05', '10:05', '12:05', '14:05', '16:05', '18:05', '20:05', '22:05'],
  };

  static const Map<String, String> eventNames = {
    'abuela': 'ABUELA',
    'tortuga': 'TORTUGA',
    'geyser': 'GÉYSER',
  };

  static const Map<String, IconData> eventIcons = {
    'abuela': Icons.elderly,
    'tortuga': Icons.pets,
    'geyser': Icons.water_drop,
  };

  Map<String, bool> eventStates = {
    'abuela': true,
    'tortuga': true,
    'geyser': true,
  };

  final Map<String, DateTime> _cachedNextEvents = {};
  int _lastMinute = -1;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _initialize();
  }

  Future<void> _initialize() async {
    _currentPSTTime = tz.TZDateTime.now(tz.getLocation('America/Los_Angeles'));
    _recalculateNextEvents();
    
    setState(() {
      _isCalculating = false;
    });

    _requestPermissions();
    await _loadEventStates();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  Future<void> _requestPermissions() async {
    try {
      await Future.wait([
        Permission.notification.request(),
        Permission.scheduleExactAlarm.request(),
      ]);
    } catch (e) {
      debugPrint('Error permisos: $e');
    }
  }

  void _updateTime() {
    final now = tz.TZDateTime.now(tz.getLocation('America/Los_Angeles'));
    
    if (_lastMinute != now.minute) {
      _lastMinute = now.minute;
      _recalculateNextEvents();
    }
    
    setState(() {
      _currentPSTTime = now;
    });
  }

  void _recalculateNextEvents() {
    for (var entry in eventosPST.entries) {
      _cachedNextEvents[entry.key] = _getNextEventTime(entry.value);
    }
  }

  Future<void> _loadEventStates() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, bool> loadedStates = {};
    
    for (var key in eventStates.keys) {
      loadedStates[key] = prefs.getBool('event_$key') ?? true;
    }
    
    setState(() {
      eventStates = loadedStates;
    });
    
    await NotificationService.instance.scheduleAllNotifications(eventosPST, eventStates);
  }

  Future<void> _toggleEventState(String eventKey) async {
    final newState = !eventStates[eventKey]!;
    
    setState(() {
      eventStates[eventKey] = newState;
    });
    
    AudioService.instance.playToggle(newState);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('event_$eventKey', newState);
    await NotificationService.instance.scheduleAllNotifications(eventosPST, eventStates);
  }

  DateTime _getNextEventTime(List<String> times) {
    final now = _currentPSTTime;
    DateTime? closestEvent;
    int smallestDifference = 999999;
    
    for (var timeStr in times) {
      final parts = timeStr.split(':');
      final eventHour = int.parse(parts[0]);
      final eventMinute = int.parse(parts[1]);
      
      var eventTime = tz.TZDateTime(
        tz.getLocation('America/Los_Angeles'),
        now.year, now.month, now.day,
        eventHour, eventMinute, 0,
      );
      
      if (eventTime.isBefore(now)) {
        eventTime = eventTime.add(const Duration(days: 1));
      }
      
      final differenceInMinutes = eventTime.difference(now).inMinutes;
      
      if (differenceInMinutes < smallestDifference) {
        smallestDifference = differenceInMinutes;
        closestEvent = eventTime;
      }
    }
    
    return closestEvent ?? now;
  }

  String _getTimeRemaining(DateTime nextEvent) {
    final difference = nextEvent.difference(_currentPSTTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool _isEventActive(String eventKey) {
    final times = eventosPST[eventKey]!;
    final now = _currentPSTTime;
    
    for (var timeStr in times) {
      final parts = timeStr.split(':');
      final eventHour = int.parse(parts[0]);
      final eventMinute = int.parse(parts[1]);
      
      var eventTime = tz.TZDateTime(
        tz.getLocation('America/Los_Angeles'),
        now.year, now.month, now.day,
        eventHour, eventMinute, 0,
      );
      
      // Si el evento ya pasó hoy, no lo consideramos activo
      if (eventTime.isBefore(now.subtract(const Duration(hours: 1)))) {
        continue;
      }
      
      // Verificar si estamos dentro de los 10 minutos después del evento
      final eventEnd = eventTime.add(const Duration(minutes: 10));
      
      if (now.isAfter(eventTime) && now.isBefore(eventEnd)) {
        return true;
      }
    }
    
    return false;
  }

  void _showThemeSelector() {
    final theme = ThemeManager.instance.currentTheme;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.bgDark2,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: theme.primaryNeon.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ShaderMask(
                shaderCallback: (bounds) => theme.headerGradient.createShader(bounds),
                child: Text(
                  'SELECCIONAR TEMA',
                  style: theme.headerTextStyle.copyWith(fontSize: 20),
                ),
              ),
            ),
            ...ThemeManager.instance.availableThemes.map((t) => ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: t.id == theme.id ? t.primaryNeon : t.primaryNeon.withOpacity(0.3),
                    width: 2,
                  ),
                  gradient: LinearGradient(colors: [t.primaryNeon, t.secondaryNeon]),
                ),
              ),
              title: Text(
                t.name,
                style: TextStyle(
                  color: t.id == theme.id ? t.primaryNeon : Colors.white,
                  fontWeight: t.id == theme.id ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: t.id == theme.id
                  ? Icon(Icons.check_circle, color: t.primaryNeon)
                  : null,
              onTap: () {
                ThemeManager.instance.setTheme(t);
                Navigator.pop(context);
                setState(() {});
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.instance.currentTheme;
    
    return Scaffold(
      body: Stack(
        children: [
          const DynamicBackground(),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(theme),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildClock(theme),
                        const SizedBox(height: 24),
                        _buildEventsList(theme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildThemeFAB(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.bgDark2.withOpacity(0.5),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => theme.headerGradient.createShader(bounds),
          child: Text('SKY TIMES', style: theme.headerTextStyle),
        ),
      ),
    );
  }

  Widget _buildClock(AppTheme theme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: theme.getClockDecoration(_pulseController.value),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  Text('HORA SKY', style: theme.clockLabelStyle),
                  const SizedBox(height: 10),
                  ShaderMask(
                    shaderCallback: (bounds) => theme.clockGradient.createShader(bounds),
                    child: Text(
                      '${_currentPSTTime.hour.toString().padLeft(2, '0')}:${_currentPSTTime.minute.toString().padLeft(2, '0')}:${_currentPSTTime.second.toString().padLeft(2, '0')}',
                      style: theme.clockTimeStyle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.secondaryNeon.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.secondaryNeon.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'PST',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsList(AppTheme theme) {
    if (_isCalculating) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.secondaryNeon.withOpacity(0.3),
              width: 2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.bgDark2.withOpacity(0.3),
                theme.bgDark3.withOpacity(0.2),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryNeon),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'CALCULANDO EVENTOS...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: theme.primaryNeon.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final sortedEvents = eventosPST.keys.toList()
      ..sort((a, b) {
        final timeA = _cachedNextEvents[a] ?? _currentPSTTime;
        final timeB = _cachedNextEvents[b] ?? _currentPSTTime;
        return timeA.difference(_currentPSTTime).compareTo(timeB.difference(_currentPSTTime));
      });

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.secondaryNeon.withOpacity(0.3),
            width: 2,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.bgDark2.withOpacity(0.3),
              theme.bgDark3.withOpacity(0.2),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [theme.accentNeon, theme.secondaryNeon],
                      ).createShader(bounds),
                      child: const Text(
                        'EVENTOS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.flash_on, color: theme.primaryNeon, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedEvents.length,
                    itemBuilder: (context, index) {
                      final eventKey = sortedEvents[index];
                      final nextEvent = _cachedNextEvents[eventKey] ?? _currentPSTTime;
                      final timeRemaining = _getTimeRemaining(nextEvent);
                      final isEnabled = eventStates[eventKey] ?? true;
                      final isNext = index == 0;
                      final isActive = _isEventActive(eventKey);

                      return _buildEventCard(
                        theme,
                        eventKey,
                        eventNames[eventKey]!,
                        nextEvent,
                        timeRemaining,
                        isEnabled,
                        isNext,
                        isActive,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
    AppTheme theme,
    String eventKey,
    String name,
    DateTime nextEvent,
    String timeRemaining,
    bool isEnabled,
    bool isNext,
    bool isActive,
  ) {
    return AnimatedBuilder(
      animation: isNext ? _glowController : _pulseController,
      builder: (context, child) {
        final animValue = isNext ? _glowController.value : _pulseController.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: theme.getCardDecoration(isEnabled, isNext, animValue),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Semáforo de estado
                    _buildStatusLight(theme, isActive, isEnabled),
                    const SizedBox(width: 12),
                    
                    Container(
                      width: 50,
                      height: 50,
                      decoration: theme.getIconDecoration(isEnabled, isNext),
                      child: Icon(
                        eventIcons[eventKey],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: theme.eventTitleStyle.copyWith(
                                  color: isEnabled ? Colors.white : Colors.white38,
                                ),
                              ),
                              if (isNext && isEnabled) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: theme.getNextBadgeDecoration(),
                                  child: const Text(
                                    'NEXT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: isEnabled ? theme.primaryNeon : Colors.white24,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${nextEvent.hour.toString().padLeft(2, '0')}:${nextEvent.minute.toString().padLeft(2, '0')} PST',
                                style: theme.eventTimeStyle.copyWith(
                                  color: isEnabled ? theme.eventTimeStyle.color : Colors.white24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: isEnabled ? theme.accentNeon : Colors.white24,
                              ),
                              const SizedBox(width: 6),
                              ShaderMask(
                                shaderCallback: (bounds) => (isEnabled 
                                    ? theme.timeRemainingGradient 
                                    : const LinearGradient(colors: [Colors.white24, Colors.white24])
                                ).createShader(bounds),
                                child: Text(
                                  timeRemaining,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'monospace',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    Transform.scale(
                      scale: 0.9,
                      child: Switch(
                        value: isEnabled,
                        onChanged: (value) => _toggleEventState(eventKey),
                        activeColor: theme.switchActiveColor,
                        activeTrackColor: theme.switchActiveTrackColor,
                        inactiveThumbColor: theme.switchInactiveThumbColor,
                        inactiveTrackColor: theme.switchInactiveTrackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusLight(AppTheme theme, bool isActive, bool isEnabled) {
    if (!isEnabled) {
      // Evento desactivado - sin luz
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.3),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final pulseValue = 0.3 + (_glowController.value * 0.7);
        final lightColor = isActive ? Colors.green : Colors.red;
        
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightColor.withOpacity(pulseValue),
            border: Border.all(
              color: lightColor.withOpacity(0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: lightColor.withOpacity(pulseValue * 0.8),
                blurRadius: 8 + _glowController.value * 4,
                spreadRadius: 1 + _glowController.value * 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeFAB(AppTheme theme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.secondaryNeon.withOpacity(0.5 + _pulseController.value * 0.3),
                blurRadius: 20 + _pulseController.value * 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _showThemeSelector,
            backgroundColor: theme.bgDark2,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [theme.secondaryNeon, theme.accentNeon],
              ).createShader(bounds),
              child: const Icon(
                Icons.palette_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    
    const androidChannel = AndroidNotificationChannel(
      'sky_events',
      'Sky Events',
      description: 'Notificaciones de eventos de Sky',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
      await androidPlugin.requestNotificationsPermission();
      
      if (await androidPlugin.canScheduleExactNotifications() == false) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
    
    _initialized = true;
  }

  Future<void> scheduleAllNotifications(
    Map<String, List<String>> eventos,
    Map<String, bool> estados,
  ) async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      debugPrint('Error cancelando: $e');
    }

    int notificationsScheduled = 0;

    for (var entry in eventos.entries) {
      final eventKey = entry.key;
      final times = entry.value;
      final isEnabled = estados[eventKey] ?? true;

      if (!isEnabled) continue;

      for (var timeStr in times) {
        final scheduled = await _scheduleNotificationsForTime(eventKey, timeStr);
        notificationsScheduled += scheduled;
      }
    }
  }

  Future<int> _scheduleNotificationsForTime(String eventKey, String timeStr) async {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    const eventNames = {
      'abuela': 'Abuela',
      'tortuga': 'Tortuga',
      'geyser': 'Géyser',
    };

    int scheduled = 0;

    bool result1 = await _scheduleNotification(eventKey, eventNames[eventKey]!, hour, minute, 10);
    if (result1) scheduled++;

    bool result2 = await _scheduleNotification(eventKey, eventNames[eventKey]!, hour, minute, 1);
    if (result2) scheduled++;

    return scheduled;
  }

  Future<bool> _scheduleNotification(
    String eventKey,
    String eventName,
    int hour,
    int minute,
    int minutesBefore,
  ) async {
    try {
      final pstLocation = tz.getLocation('America/Los_Angeles');
      final now = tz.TZDateTime.now(pstLocation);
      
      var eventTime = tz.TZDateTime(
        pstLocation,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        0,
      );

      eventTime = eventTime.subtract(Duration(minutes: minutesBefore));

      if (eventTime.isBefore(now)) {
        eventTime = eventTime.add(const Duration(days: 1));
      }

      final id = ('${eventKey}_${hour}_${minute}_$minutesBefore').hashCode.abs() % 2147483647;

      const androidDetails = AndroidNotificationDetails(
        'sky_events',
        'Sky Events',
        channelDescription: 'Notificaciones de eventos de Sky',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        enableVibration: true,
        ticker: 'ticker',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        eventName,
        minutesBefore == 10
            ? '¡Comienza en 10 minutos!'
            : '¡Comienza en 1 minuto!',
        eventTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '$eventKey|$hour|$minute|$minutesBefore',
      );
      
      return true;
    } catch (e) {
      debugPrint('Error scheduling: $e');
      return false;
    }
  }
}