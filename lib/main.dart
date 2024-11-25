import 'package:fit_quest/screens/home_screen.dart';
import 'package:fit_quest/screens/main_menu_screen.dart';
import 'package:fit_quest/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/hero_model.dart';
import 'models/shop_model.dart';
import 'screens/shop_screen.dart';
import 'utils/BGMPlayer.dart';

void main() {
  final BGMPlayer bgmPlayer = BGMPlayer();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HeroModel()),
        ChangeNotifierProxyProvider<HeroModel, ShopModel>(
          create: (context) => ShopModel(context.read<HeroModel>()),
          update: (context, heroModel, shopModel) {
            shopModel?.updateHeroModel(heroModel); // Update heroModel in the existing ShopModel
            return shopModel!;
          },
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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => const MainMenuScreen(),
        '/home': (context) => const HomeScreen(), // Define the home screen route
        '/shop': (context) => ShopScreen(), // Define the shop screen route, if needed
      },
    );
  }

}
