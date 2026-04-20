import 'package:flutter/cupertino.dart';

class PlantsScreen extends StatelessWidget {
  const PlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Pflanzen'),
      ),
      child: Center(child: Text('Pflanzen kommen gleich 🌱')),
    );
  }
}