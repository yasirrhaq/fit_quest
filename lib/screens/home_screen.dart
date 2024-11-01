import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';
import '../widgets/quest_tile.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final heroModel = Provider.of<HeroModel>(context, listen: false);

    final List<Widget> _screens = [
      _buildHomeContent(context, heroModel),
      ShopScreen(),
      const ProfileScreen(),
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Fit Quest' : _selectedIndex == 1 ? 'Shop' : 'Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showResetConfirmationDialog(context, heroModel);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gymbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, HeroModel heroModel) {
    return Stack(
      children: [
        Positioned(
          top: 26,
          right: 16,
          child: Row(
            children: [
              Image.asset(
                'assets/images/gold.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 4),
              Consumer<HeroModel>(
                builder: (context, hero, child) {
                  return Text(
                    '${hero.gold}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Consumer<HeroModel>(
          builder: (context, hero, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          '${hero.characterName}',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        Text(
                          'Hero Level: ${hero.level}',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            hero.resetDailyAndRepeatableQuests();
                          },
                          child: const Text('Simulate Midnight Reset'),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: hero.xp / hero.xpRequired,
                          minHeight: 10,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'XP: ${hero.xp} / ${hero.xpRequired}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.bounceInOut,
                          height: 100 + (hero.level * 5).toDouble(),
                          child: Image.asset(
                            heroModel.activeCharacter,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Daily Quests',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hero.dailyQuests.length,
                    itemBuilder: (context, index) {
                      final dailyQuest = hero.dailyQuests[index];
                      final difficulty = dailyQuest['selectedDifficulty'];
                      final difficultyData =
                          dailyQuest['difficulties'][difficulty];
                      final maxCount = difficultyData['repetitions'] ??
                          difficultyData['duration'];
                      final currentCount = dailyQuest['count'] ?? 0;

                      return QuestTile(
                        questName: dailyQuest['name'],
                        difficulty: difficulty,
                        xpReward: difficultyData['xpReward'],
                        maxCount: maxCount,
                        currentCount: currentCount,
                        onIncrement: () {
                          hero.incrementDailyQuest(index);
                        },
                        onDecrement: () {
                          hero.decrementDailyQuest(index);
                        },
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Repeatable Quests (Up to 10 times each)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hero.repeatableQuests.length,
                    itemBuilder: (context, index) {
                      final repeatableQuest = hero.repeatableQuests[index];
                      final difficulty = repeatableQuest['selectedDifficulty'];
                      final difficultyData =
                          repeatableQuest['difficulties'][difficulty];
                      final maxCount = difficultyData['repetitions'] ??
                          difficultyData['duration'];
                      final currentCount = repeatableQuest['count'] ?? 0;

                      return QuestTile(
                        questName: repeatableQuest['name'],
                        difficulty: difficulty,
                        xpReward: difficultyData['xpReward'],
                        maxCount: maxCount,
                        currentCount: currentCount,
                        onIncrement: () {
                          hero.incrementRepeatableQuest(index);
                        },
                        onDecrement: () {
                          hero.decrementRepeatableQuest(index);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showResetConfirmationDialog(BuildContext context, HeroModel heroModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Progression"),
          content: const Text(
              "Are you sure you want to delete all progression data?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                heroModel.resetProgression();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
