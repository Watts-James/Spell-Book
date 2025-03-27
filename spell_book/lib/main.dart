import 'package:flutter/material.dart';
import 'Router/Router.dart';
import 'package:provider/provider.dart';
import 'package:spell_book/Screens/AllSpells/AllSpellsViewModel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AllSpellsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
