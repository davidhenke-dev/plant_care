import 'package:flutter/cupertino.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Standorte'),
      ),
      child: Center(child: Text('Standorte kommen gleich 📍')),
    );
  }
}