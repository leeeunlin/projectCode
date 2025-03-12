import 'package:rayo/db/hive_db.dart';
import 'package:rayo/utils/import_index.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
// late WidgetsBinding engine;
Future<void> forceAppUpdate() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await WidgetsBinding.instance.performReassemble(); // force rebuild
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveDB.instance.init();
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('ja'),
        Locale('ko'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    const MaterialColor swatchColor = MaterialColor(
      0xFFFFD400,
      <int, Color>{
        50: Color(0xFFFFD400),
        100: Color(0xFFFFD400),
        200: Color(0xFFFFD400),
        300: Color(0xFFFFD400),
        400: Color(0xFFFFD400),
        500: Color(0xFFFFD400),
        600: Color(0xFFFFD400),
        700: Color(0xFFFFD400),
        800: Color(0xFFFFD400),
        900: Color(0xFFFFD400),
      },
    );
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        // 디바이스 텍스트 확대 무시처리
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1),
            boldText: false,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        sliderTheme:
            SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
        snackBarTheme: SnackBarThemeData(
            insetPadding: EdgeInsets.zero, backgroundColor: Colors.transparent),
        appBarTheme: const AppBarTheme(
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFC8C8D2),
              width: 0.25,
            ),
          ),
          toolbarHeight: 66,
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        datePickerTheme: DatePickerThemeData(
          dayShape: WidgetStatePropertyAll<OutlinedBorder>(
            CircleBorder(
              side: BorderSide(width: 5, color: white),
            ),
          ),
          todayBorder: BorderSide(width: 5, color: white),
          dayStyle: TextStyle(
            color: black[80],
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 21 / 14,
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
            color: yellow, circularTrackColor: black[20]),
        colorScheme: ColorScheme.light(primary: yellow),
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: swatchColor,
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              height: 27 / 18,
              color: black),
          titleMedium: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 24 / 16,
              color: black),
          bodyLarge: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 21 / 14,
              color: black),
          bodyMedium: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 18 / 12,
            color: black[80],
          ),
          labelLarge: TextStyle(
              fontFamily: 'MCMerchant',
              fontSize: 12,
              height: 18 / 12,
              color: black[60]),
        ),
      ),
      initialRoute: NAV_Root,
      onGenerateRoute: (settings) => routeFunc(settings),
    );
  }
}
