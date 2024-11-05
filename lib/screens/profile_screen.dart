import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroModel = Provider.of<HeroModel>(context);

    return DefaultTabController(
      length: 2, // Two tabs: Characters and Backgrounds
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Characters"),
              Tab(text: "Backgrounds"),
            ],
          ),
          title: const Text("Profile"),
        ),
        body: TabBarView(
          children: [
            _buildCharacterGrid(heroModel),  // Characters tab
            _buildBackgroundGrid(heroModel), // Backgrounds tab
          ],
        ),
      ),
    );
  }

  // Helper method to display owned characters in a grid
  Widget _buildCharacterGrid(HeroModel heroModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: heroModel.ownedCharacters.length,
        itemBuilder: (context, index) {
          final character = heroModel.ownedCharacters[index];
          return GestureDetector(
            onTap: () {
              heroModel.setActiveCharacter(character);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selected as active character!')),
              );
            },
            child: Stack(
              children: [
                Image.asset(character.image, fit: BoxFit.cover),
                if (character == heroModel.activeCharacter)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to display owned backgrounds in a grid
  Widget _buildBackgroundGrid(HeroModel heroModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: heroModel.ownedBackgrounds.length,
        itemBuilder: (context, index) {
          final background = heroModel.ownedBackgrounds[index];
          return GestureDetector(
            onTap: () {
              heroModel.setActiveBackground(background);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selected as active background!')),
              );
            },
            child: Stack(
              children: [
                Image.asset(background.image, fit: BoxFit.cover),
                if (background == heroModel.activeBackground)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
