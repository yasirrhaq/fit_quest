import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HeroModel extends ChangeNotifier {
  int level = 1;
  int xp = 0;
  int xpRequired = 100;
  int resetSignal = 0; // Increment this to signal a reset
  int gold = 0;

  String characterName = "bugon_dev";
  String activeCharacter = 'assets/images/default.png'; // Default character image
  List<String> ownedCharacters = ['assets/images/default.png']; // Starting with default character



  final List<Map<String, dynamic>> dailyQuestPool = [
    {
      'name': 'Jumping Jacks',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Push-Ups',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Plank Hold',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'duration': 15, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'duration': 30, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'duration': 45, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'duration': 60, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Burpees',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 5, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 10, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 15, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 20, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'High Knees',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'duration': 15, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'duration': 30, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'duration': 45, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'duration': 60, 'xpReward': 80, 'goldReward': 50},
      },
    },
  ];

  final List<Map<String, dynamic>> repeatableQuestPool = [
    {
      'name': 'Bicep Curls',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Squats',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Lunges',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 40, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Mountain Climbers',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 15, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 30, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 45, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 60, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Jump Rope',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'duration': 15, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'duration': 30, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'duration': 45, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'duration': 60, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Bicycle Crunches',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 40, 'xpReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Russian Twists',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'xpReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'xpReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'xpReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'xpReward': 80, 'goldReward': 50},
      },
    },
  ];

  List<Map<String, dynamic>> dailyQuests = [];
  List<Map<String, dynamic>> repeatableQuests = [];


  Timer? resetTimer;

  HeroModel() {
    _loadProgression();
    _startMidnightResetTimer();
    _selectRandomDailyQuests();
    _selectRandomRepeatableQuests();
  }

  // Function to randomize difficulty for a given quest list
  List<Map<String, dynamic>> _getQuestsWithRandomDifficulty(List<Map<String, dynamic>> questPool) {
    final random = Random();
    const difficulties = ['Easy', 'Medium', 'Hard', 'Extreme'];

    return questPool.map((quest) {
      final randomizedQuest = Map<String, dynamic>.from(quest);
      randomizedQuest['selectedDifficulty'] = difficulties[random.nextInt(difficulties.length)];
      return randomizedQuest;
    }).toList();
  }

  void _selectRandomDailyQuests() {
    final random = Random();
    final dailyPool = _getQuestsWithRandomDifficulty(
        dailyQuestPool.where((quest) => quest['type'] == 'daily').toList());
    dailyPool.shuffle(random);
    dailyQuests = dailyPool.sublist(0, 3);
    notifyListeners();
  }

  void _selectRandomRepeatableQuests() {
    final random = Random();
    final repeatablePool = _getQuestsWithRandomDifficulty(
        List<Map<String, dynamic>>.from(repeatableQuestPool));
    repeatablePool.shuffle(random);
    repeatableQuests = repeatablePool.sublist(0, 3);
    notifyListeners();
  }

  Future<void> _loadProgression() async {
    final prefs = await SharedPreferences.getInstance();
    level = prefs.getInt('level') ?? 1;
    xp = prefs.getInt('xp') ?? 0;
    xpRequired = prefs.getInt('xpRequired') ?? 100;
    gold = prefs.getInt('gold') ?? 0;
    characterName = prefs.getString('characterName') ?? "bugon_dev";
    notifyListeners(); // Notify listeners to update the UI with loaded data
  }

  Future<void> _saveProgression() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', level);
    await prefs.setInt('xp', xp);
    await prefs.setInt('xpRequired', xpRequired);
    await prefs.setInt('gold', gold);
    await prefs.setString('characterName', characterName);
  }

  void setCharacterName(String name) {
    characterName = name;
    _saveProgression(); // Save the character name to preferences
    notifyListeners();
  }

  Future<void> resetProgression() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data

    // Reset in-memory variables to default values
    level = 1;
    xp = 0;
    xpRequired = 100;
    gold = 0;
    characterName = "";

    notifyListeners(); // Update the UI
  }

  // Purchase a new character
  void purchaseCharacter(String characterImage, int price) {
    if (gold >= price && !ownedCharacters.contains(characterImage)) {
      gold -= price;
      ownedCharacters.add(characterImage);
      notifyListeners();
    }
  }

  // Set a character as active
  void setActiveCharacter(String characterImage) {
    activeCharacter = characterImage;
    notifyListeners();
  }

  void _startMidnightResetTimer() {
    // Check every minute if the time is midnight (00:00)
    resetTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        resetDailyAndRepeatableQuests();
      }
    });
  }

  // Increment progress for a daily quest with null checks
  void incrementDailyQuest(int index) {
    final dailyQuest = dailyQuests[index];
    String difficulty = dailyQuest['selectedDifficulty'];
    int maxCount = dailyQuest['difficulties'][difficulty]['repetitions'] ?? dailyQuest['difficulties'][difficulty]['duration'] ?? 10;
    int xpReward = dailyQuest['difficulties'][difficulty]['xpReward'];
    int goldReward = dailyQuest['difficulties'][difficulty]['goldReward'];

    if ((dailyQuest['count'] ?? 0) < maxCount) {
      dailyQuest['count'] = (dailyQuest['count'] ?? 0) + 1;

      // Award XP and gold only if quest is fully completed
      if (dailyQuest['count'] == maxCount) {
        xp += xpReward;
        gold += goldReward;

        if (xp >= xpRequired) {
          levelUp();
        }

        _saveProgression();
      }
      notifyListeners();
    }
  }

  void incrementRepeatableQuest(int index) {
    final repeatableQuest = repeatableQuests[index];
    String difficulty = repeatableQuest['selectedDifficulty'];
    int maxCount = repeatableQuest['difficulties'][difficulty]['repetitions'] ?? repeatableQuest['difficulties'][difficulty]['duration'] ?? 10;
    int xpReward = repeatableQuest['difficulties'][difficulty]['xpReward'];
    int goldReward = repeatableQuest['difficulties'][difficulty]['goldReward'];

    if ((repeatableQuest['count'] ?? 0) < maxCount) {
      repeatableQuest['count'] = (repeatableQuest['count'] ?? 0) + 1;

      // Award XP and gold only if quest is fully completed
      if (repeatableQuest['count'] == maxCount) {
        xp += xpReward;
        gold += goldReward;

        if (xp >= xpRequired) {
          levelUp();
        }

        _saveProgression();
      }
      notifyListeners();
    }
  }

  void decreaseGold(int amount) {
    if (gold >= amount) {
      gold -= amount;
      notifyListeners();
    }
  }

  // Decrement progress for a daily quest with null checks
  void decrementDailyQuest(int index) {
    final dailyQuest = dailyQuests[index];
    String difficulty = dailyQuest['selectedDifficulty'];
    int xpReward = dailyQuest['difficulties'][difficulty]['xpReward'] ?? 0;

    if ((dailyQuest['count'] ?? 0) > 0) {
      dailyQuest['count'] = (dailyQuest['count'] ?? 0) - 1;
      xp -= xpReward;

      if (xp < 0) xp = 0;
      notifyListeners();
    }
  }

  // Decrement progress for a repeatable quest with null checks
  void decrementRepeatableQuest(int index) {
    final repeatableQuest = repeatableQuests[index];
    String difficulty = repeatableQuest['selectedDifficulty'];
    int xpReward = repeatableQuest['difficulties'][difficulty]['xpReward'] ?? 0;

    if ((repeatableQuest['count'] ?? 0) > 0) {
      repeatableQuest['count'] = (repeatableQuest['count'] ?? 0) - 1;
      xp -= xpReward;

      if (xp < 0) xp = 0;
      notifyListeners();
    }
  }

  void resetDailyAndRepeatableQuests() {
    resetSignal++; // Increment to signal all active timers to stop
    // Clear existing quests to avoid duplicates
    dailyQuests.clear();
    repeatableQuests.clear();

    // Reset counts and completion status for daily and repeatable quests
    for (var quest in dailyQuestPool) {
      quest['completed'] = false;
      quest['count'] = 0;
    }

    for (var quest in repeatableQuestPool) {
      quest['count'] = 0;
    }

    // Select new random daily and repeatable quests
    _selectRandomDailyQuests();
    _selectRandomRepeatableQuests();

    notifyListeners(); // Notify listeners to refresh the UI
  }


  void levelUp() {
    level++;
    xp = 0;
    xpRequired += 20 * level; // Increase XP requirement with each level
    _saveProgression();
  }

  @override
  void dispose() {
    resetTimer?.cancel(); // Cancel the timer when HeroModel is disposed
    super.dispose();
  }
}