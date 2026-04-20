import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Heute'),
      ),
      child: Center(
        child: Text('Homepage kommt gleich 🌿'),
      ),
    );
  }
}