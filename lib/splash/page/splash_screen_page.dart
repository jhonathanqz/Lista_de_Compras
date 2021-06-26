import 'package:flutter/material.dart';
import 'package:lista_compras/lista/page/lista_de_compras_page.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  var _opacity = 0.0;

  Future<void> showLogo() async {
    //setState(() => _opacity = 0.5);
    await Future.delayed(
      Duration(
        seconds: 1,
      ),
    );
    setState(() => _opacity = 1.0);
    await Future.delayed(
      Duration(
        seconds: 2,
      ),
    );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ListaDeCompras()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    showLogo();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1.5,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
        ],
      ),
    );
  }
}
