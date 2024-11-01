import 'package:fit_quest/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/hero_model.dart';
import 'models/shop_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HeroModel()),
        ChangeNotifierProxyProvider<HeroModel, ShopModel>(
          create: (context) => ShopModel(context.read<HeroModel>()),
          update: (context, heroModel, shopModel) => ShopModel(heroModel),
        ),
      ],
      child: const FitQuestApp(),
    ),
  );
}

class FitQuestApp extends StatelessWidget {
  const FitQuestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitQuest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenuScreen(),
    );
  }
}
