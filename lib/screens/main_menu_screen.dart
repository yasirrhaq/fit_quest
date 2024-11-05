import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_quest/models/hero_model.dart';
import 'home_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with SingleTickerProviderStateMixin {
  double _opacity = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBlinkingAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBlinkingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.3 : 1.0; // Toggle opacity between 1 and 0.3
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final heroModel = Provider.of<HeroModel>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        if (heroModel.characterName.isEmpty) {
          await _showCharacterNameDialog(context, heroModel);
        }
        // Navigate to HomeScreen after setting character name
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/mainmenu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Semi-transparent overlay for better text visibility
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            // Blinking "Tap to Start" text positioned lower on the screen
            Positioned(
              bottom: 150, // Adjust this value to set how far from the bottom
              left: 15,
              right: 0,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 700),
                child: const Center(
                  child: Text(
                    "Tap to Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCharacterNameDialog(BuildContext context, HeroModel heroModel) async {
    TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Your Character Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Character Name",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  heroModel.setCharacterName(name);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
