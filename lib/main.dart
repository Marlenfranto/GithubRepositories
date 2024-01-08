import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'Pages/home_screen.dart';
import 'Providers/home_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repositories',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => RepositoryProvider(),
        child: HomePage(),
      ),
    );
  }
}




