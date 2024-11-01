import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_quest/models/hero_model.dart'; // Import your HeroModel here
import 'home_screen.dart'; // Import your HomeScreen here

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroModel = Provider.of<HeroModel>(context, listen: false);

    return Scaffold(
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
          // Main Menu Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (heroModel.characterName.isEmpty) {
                      await _showCharacterNameDialog(context, heroModel);
                    }
                    // Navigate to HomeScreen after setting character name
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text("Start"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the app or navigate as needed
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text("Exit"),
                ),
              ],
            ),
          ),
        ],
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
            decoration: const InputDecoration(hintText: "Character Name"),
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
