import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroModel = Provider.of<HeroModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Owned Characters',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
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
                        Image.asset(character, fit: BoxFit.cover),
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
            ),
          ],
        ),
      ),
    );
  }
}
