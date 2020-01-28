import 'package:flutter/material.dart';
import 'package:moviedatabase/di/dependency_injection.dart' as di;
import 'package:moviedatabase/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

Map<int, Color> primaryColor = {
  50: Color.fromRGBO(154, 28, 35, .1),
  100: Color.fromRGBO(154, 28, 35, .2),
  200: Color.fromRGBO(154, 28, 35, .3),
  300: Color.fromRGBO(154, 28, 35, .4),
  400: Color.fromRGBO(154, 28, 35, .5),
  500: Color.fromRGBO(154, 28, 35, .6),
  600: Color.fromRGBO(154, 28, 35, .7),
  700: Color.fromRGBO(154, 28, 35, .8),
  800: Color.fromRGBO(154, 28, 35, .9),
  900: Color.fromRGBO(154, 28, 35, 1)
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Database',
      theme: ThemeData(
        primaryColor: Color(0xFF9A1C23),
        primaryColorDark: Color(0xFF74151A),
        accentColor: Color(0xFFEBE5D2),
        primarySwatch: MaterialColor(0xFF9A1C23, primaryColor),
        bottomAppBarColor: Color(0xFF9A1C23),
        splashColor: Color(0xFF9A1C23),
      ),
      home: Scaffold(
        body: SplashPage(),
      ),
    );
  }
}
