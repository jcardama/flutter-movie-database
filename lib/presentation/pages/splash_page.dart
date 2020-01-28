import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviedatabase/presentation/pages/movies_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MoviesPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
            opacity: 1,
            child: SvgPicture.asset('assets/logo.svg'),
          ),
        ),
      ),
    );
  }
}
