import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'asset_model.dart';

class HeroModel extends ChangeNotifier {
  int level = 1;
  int exp = 0;
  int expRequired = 100;
  int resetSignal = 0; // Increment this to signal a reset
  int gold = 0;
  int totalRepeatableCount = 0;

  bool repeatableDisabled = false;

  Timer? _debounceTimer;

  final ValueNotifier<bool> levelUpNotifier = ValueNotifier(false);

  String characterName = "bugon_dev";

  AssetModel? activeCharacter; // Reference to the active character asset
  AssetModel? activeBackground; // Reference to the active background asset

  // Fallback active character getter
  AssetModel get currentActiveCharacter => activeCharacter ?? defaultCharacter;

  List<AssetModel> ownedAssets = [];

  final AssetModel defaultCharacter = AssetModel(
    id: "0",
    name: "Default Character",
    image: "assets/images/default.png",
    price: 0,
    category: "Character",
    isPurchased: true,
  );

  final AssetModel defaultBackground = AssetModel(
    id: "99",
    name: "Default Background",
    image: "assets/images/gymbg.png",
    price: 0,
    category: "Background",
    isPurchased: true,
  );

  final Map<int, String> levelAsset = {
    4: 'assets/images/character.png',
    3: 'assets/images/man-workout.png',
    2: 'assets/images/baby-head.png',
    1: 'assets/images/default.png', // Default image for level 1
  };

  final List<Map<String, dynamic>> dailyQuestPool = [
    {
      'name': 'Jumping Jacks',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Push-Ups',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Plank Hold',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'duration': 15, 'expReward': 10, 'goldReward': 10},
        'Medium': {'duration': 30, 'expReward': 25, 'goldReward': 20},
        'Hard': {'duration': 45, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'duration': 60, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Burpees',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 5, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 10, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 15, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 20, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'High Knees',
      'type': 'daily',
      'completed': false,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'duration': 15, 'expReward': 10, 'goldReward': 10},
        'Medium': {'duration': 30, 'expReward': 25, 'goldReward': 20},
        'Hard': {'duration': 45, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'duration': 60, 'expReward': 80, 'goldReward': 50},
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
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Squats',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Lunges',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 40, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Mountain Climbers',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 15, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 30, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 45, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 60, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Jump Rope',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'duration': 15, 'expReward': 10, 'goldReward': 10},
        'Medium': {'duration': 30, 'expReward': 25, 'goldReward': 20},
        'Hard': {'duration': 45, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'duration': 60, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Bicycle Crunches',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 40, 'expReward': 80, 'goldReward': 50},
      },
    },
    {
      'name': 'Russian Twists',
      'type': 'repeatable',
      'count': 0,
      'selectedDifficulty': 'Easy',
      'difficulties': {
        'Easy': {'repetitions': 10, 'expReward': 10, 'goldReward': 10},
        'Medium': {'repetitions': 20, 'expReward': 25, 'goldReward': 20},
        'Hard': {'repetitions': 30, 'expReward': 50, 'goldReward': 30},
        'Extreme': {'repetitions': 50, 'expReward': 80, 'goldReward': 50},
      },
    },
  ];

  List<Map<String, dynamic>> dailyQuests = [];
  List<Map<String, dynamic>> repeatableQuests = [];

  Timer? resetTimer;

  HeroModel() {
    ownedAssets.add(defaultCharacter);
    activeCharacter = defaultCharacter;

    ownedAssets.add(defaultBackground);
    activeBackground = defaultBackground;

    _loadProgression();
    _startMidnightResetTimer();
    _selectRandomDailyQuests();
    _selectRandomRepeatableQuests();
  }

  bool canAfford(int price) => this.gold >= price;

  void purchaseAsset(AssetModel asset) {
    if (canAfford(asset.price) && !ownedAssets.contains(asset)) {
      gold -= asset.price;
      if (!ownedAssets.contains(asset)) {
        ownedAssets.add(asset);
      }
      _saveProgression();
      notifyListeners();
    }
  }

  void setActiveCharacter(AssetModel character) {
    if (character.category == 'Character') {
      activeCharacter = character;
      _saveProgression();
      notifyListeners();
    }
  }

  void setActiveBackground(AssetModel background) {
    if (background.category == 'Background') {
      activeBackground = background;
      _saveProgression();
      notifyListeners();
    }
  }

  List<AssetModel> get ownedCharacters =>
      ownedAssets.where((asset) => asset.category == 'Character').toList();

  List<AssetModel> get ownedBackgrounds =>
      ownedAssets.where((asset) => asset.category == 'Background').toList();

  // // Helper method to get character image based on level
  // String _getCharacterImage(Map<int, String> asset) {
  //   // Find the highest level threshold that the current level meets or exceeds
  //   for (int levelThreshold in asset.keys.toList()
  //     ..sort((a, b) => b.compareTo(a))) {
  //     if (level >= levelThreshold) {
  //       return asset[levelThreshold]!;
  //     }
  //   }
  //   // Fallback image in case no match is found (shouldn’t happen with the current map setup)
  //   return 'assets/images/default.png';
  // }

  AssetModel _getCharacterAsset(Map<int, String> asset) {
    for (int levelThreshold in asset.keys.toList()..sort((a, b) => b.compareTo(a))) {
      if (level >= levelThreshold) {
        final characterAsset = AssetModel(
          id: 'level_$levelThreshold',
          name: 'Level $levelThreshold Character',
          price: 0,
          image: asset[levelThreshold]!,
          category: 'Character',
        );

        // Set the character as active after acquiring it
        setActiveCharacter(characterAsset);

        return characterAsset;
      }
    }
    // Fallback asset
    return defaultCharacter;
  }

  void resetLevelUpNotifier() {
    levelUpNotifier.value = false;
  }

  // Function to randomize difficulty for a given quest list
  List<Map<String, dynamic>> _getQuestsWithRandomDifficulty(
      List<Map<String, dynamic>> questPool) {
    final random = Random();
    const difficulties = ['Easy', 'Medium', 'Hard', 'Extreme'];

    return questPool.map((quest) {
      final randomizedQuest = Map<String, dynamic>.from(quest);
      randomizedQuest['selectedDifficulty'] =
          difficulties[random.nextInt(difficulties.length)];
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

    // Load basic progression data
    level = prefs.getInt('level') ?? 1;
    exp = prefs.getInt('exp') ?? 0;
    expRequired = prefs.getInt('expRequired') ?? 100;
    gold = prefs.getInt('gold') ?? 0;
    characterName = prefs.getString('characterName') ?? "bugon_dev";

    // Load quest progress
    final dailyQuestsString = prefs.getString('dailyQuests');
    if (dailyQuestsString != null) {
      dailyQuests = List<Map<String, dynamic>>.from(jsonDecode(dailyQuestsString));
    }

    final repeatableQuestsString = prefs.getString('repeatableQuests');
    if (repeatableQuestsString != null) {
      repeatableQuests = List<Map<String, dynamic>>.from(jsonDecode(repeatableQuestsString));
    }

    // Load owned assets and deserialize JSON strings
    List<String>? ownedAssetsJson = prefs.getStringList('ownedAssets');
    if (ownedAssetsJson != null) {
      ownedAssets = ownedAssetsJson
          .map((json) => AssetModel.fromJson(jsonDecode(json)))
          .toList();
    }

    // Load active character and background
    String? activeCharacterJson = prefs.getString('activeCharacter');
    if (activeCharacterJson != null) {
      activeCharacter = AssetModel.fromJson(jsonDecode(activeCharacterJson));
    }

    String? activeBackgroundJson = prefs.getString('activeBackground');
    if (activeBackgroundJson != null) {
      activeBackground = AssetModel.fromJson(jsonDecode(activeBackgroundJson));
    }

    notifyListeners();
  }

  // Future<void> _loadProgression() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   level = prefs.getInt('level') ?? 1;
  //   exp = prefs.getInt('exp') ?? 0;
  //   expRequired = prefs.getInt('expRequired') ?? 100;
  //   gold = prefs.getInt('gold') ?? 0;
  //   characterName = prefs.getString('characterName') ?? "bugon_dev";
  //   ownedAssets = prefs.getStringList('ownedAssets') ?? ownedAssets;
  //   activeCharacter =
  //       prefs.getString('activeCharacter') ?? 'assets/images/default.png';
  //   notifyListeners();
  // }

  // Convert assets to JSON strings
  Future<void> _saveProgression() async {
    final prefs = await SharedPreferences.getInstance();

    String dailyQuestsJson = jsonEncode(dailyQuests);
    String repeatableQuestsJson = jsonEncode(repeatableQuests);

    await prefs.setInt('level', level);
    await prefs.setInt('exp', exp);
    await prefs.setInt('expRequired', expRequired);
    await prefs.setInt('gold', gold);
    await prefs.setString('characterName', characterName);

    await prefs.setString('dailyQuests', dailyQuestsJson);
    await prefs.setString('repeatableQuests', repeatableQuestsJson);

    List<String> ownedAssetsJson =
        ownedAssets.map((asset) => jsonEncode(asset.toJson())).toList();
    await prefs.setStringList('ownedAssets', ownedAssetsJson);

    // Save active character and background by their IDs or serialize them too
    if (activeCharacter != null) {
      await prefs.setString(
          'activeCharacter', jsonEncode(activeCharacter!.toJson()));
    }
    if (activeBackground != null) {
      await prefs.setString(
          'activeBackground', jsonEncode(activeBackground!.toJson()));
    }
  }

  // Future<void> _saveProgression() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('level', level);
  //   await prefs.setInt('exp', exp);
  //   await prefs.setInt('expRequired', expRequired);
  //   await prefs.setInt('gold', gold);
  //   await prefs.setString('characterName', characterName);
  //   await prefs.setStringList('ownedAssets', ownedAssets);
  //   await prefs.setString('activeCharacter', activeCharacter);
  // }

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
    exp = 0;
    expRequired = 100;
    gold = 10000;
    characterName = "";
    ownedAssets.clear();
    ownedAssets.add(defaultCharacter);
    ownedAssets.add(defaultBackground);

    notifyListeners(); // Update the UI
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
    int maxCount = dailyQuest['difficulties'][difficulty]['repetitions'] ??
        dailyQuest['difficulties'][difficulty]['duration'] ??
        10;
    int expReward = dailyQuest['difficulties'][difficulty]['expReward'];
    int goldReward = dailyQuest['difficulties'][difficulty]['goldReward'];

    if ((dailyQuest['count'] ?? 0) < maxCount) {
      dailyQuest['count'] = (dailyQuest['count'] ?? 0) + 5;

      // Award exp and gold only if quest is fully completed
      if (dailyQuest['count'] == maxCount) {
        dailyQuest['completed'] = true;
        exp += expReward;
        gold += goldReward;

        if (exp >= expRequired) {
          handleLevelUp();
        }

        _saveProgression();
      }
      notifyListeners();
    }
  }

  void incrementRepeatableQuest(int index) {
    // Debounce to prevent rapid increments
    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      // Timer ends, allowing further increments after 300 ms
      _debounceTimer = null;
    });

    if (totalRepeatableCount < 10 && !repeatableDisabled) {
      final repeatableQuest = repeatableQuests[index];
      String difficulty = repeatableQuest['selectedDifficulty'];
      int maxCount = repeatableQuest['difficulties'][difficulty]
              ['repetitions'] ??
          repeatableQuest['difficulties'][difficulty]['duration'] ??
          10;
      int expReward = repeatableQuest['difficulties'][difficulty]['expReward'];
      int goldReward =
          repeatableQuest['difficulties'][difficulty]['goldReward'];

      // Count how many times quest is completed
      repeatableQuest['repeatCount'] = repeatableQuest['repeatCount'] ?? 0;

      // Increment the count by 5 instead of 1
      repeatableQuest['count'] = (repeatableQuest['count'] ?? 0) + 5;

      // If quest is completed
      if (repeatableQuest['count'] >= maxCount) {
        exp += expReward;
        gold += goldReward;

        totalRepeatableCount++; // Increment here
        print("Total Repeatable Count: $totalRepeatableCount"); // Debug log

        if (exp >= expRequired) {
          handleLevelUp();
        }

        // Reset the quest progress to make it repeatable
        repeatableQuest['count'] = 0;
        repeatableQuest['repeatCount'] += 1;

        if (totalRepeatableCount >= 10) {
          repeatableDisabled = true;
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
    int expReward = dailyQuest['difficulties'][difficulty]['expReward'] ?? 0;

    if ((dailyQuest['count'] ?? 0) > 0) {
      dailyQuest['count'] = (dailyQuest['count'] ?? 0) - 5;
      exp -= expReward;

      if (exp < 0) exp = 0;
      notifyListeners();
    }
  }

  // Decrement progress for a repeatable quest with null checks
  void decrementRepeatableQuest(int index) {
    final repeatableQuest = repeatableQuests[index];
    String difficulty = repeatableQuest['selectedDifficulty'];
    int expReward =
        repeatableQuest['difficulties'][difficulty]['expReward'] ?? 0;

    if ((repeatableQuest['count'] ?? 0) > 0) {
      repeatableQuest['count'] = (repeatableQuest['count'] ?? 0) - 5;
      exp -= expReward;

      if (exp < 0) exp = 0;
      notifyListeners();
    }
  }

  void resetDailyAndRepeatableQuests() async {
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
      quest['repeatCount'] = 0;
    }

    totalRepeatableCount = 0;
    repeatableDisabled = false;

    await _saveProgression();

    // Select new random daily and repeatable quests
    _selectRandomDailyQuests();
    _selectRandomRepeatableQuests();

    notifyListeners(); // Notify listeners to refresh the UI
  }

  void _addLevelBasedAsset(Map<int, String> asset) {
    // Find the highest level threshold in the asset map that is less than or equal to the current level
    int applicableLevel = asset.keys
        .where((key) => key <= level)
        .reduce((a, b) => a > b ? a : b);

    String newAssetImage = asset[applicableLevel]!;

    // Check if an asset with the same image already exists in ownedAssets
    bool assetAlreadyOwned = ownedAssets.any(
          (ownedAsset) => ownedAsset.image == newAssetImage,
    );

    if (!assetAlreadyOwned) {
      ownedAssets.add(
        AssetModel(
          id: 'level_$applicableLevel',  // Keeps level for tracking in ID
          name: 'Level $applicableLevel Character',
          price: 0,
          image: newAssetImage,
          category: 'Character',
        ),
      );
      notifyListeners();
    }
  }


  // void _addLevelBasedAsset(Map<int, String> asset) {
  //   if (asset.containsKey(level)) {
  //     String newAsset = asset[level]!;
  //     // Add the new asset only if it's not already owned
  //     if (!ownedAssets.contains(newAsset)) {
  //       ownedAssets.add(newAsset);
  //     }
  //   }
  // }

  // Method to gain experience and handle overflow
  void handleLevelUp() {
    // Handle level-ups while exp meets or exceeds expRequired
    while (exp >= expRequired) {
      int overflowExp = exp - expRequired; // Calculate overflow XP
      levelUp(
          overflowExp); // Perform level-up, which updates expRequired for the new level
      exp = overflowExp; // Retain only the overflow XP for the next level
    }

    notifyListeners();
  }

  void levelUp(int overflowExp) {
    level++;
    exp = 0;
    expRequired += 10 * level;
    activeCharacter = _getCharacterAsset(levelAsset);
    _addLevelBasedAsset(levelAsset);
    levelUpNotifier.value = true;
    int goldReward = level * 10;
    gold += goldReward;
    _saveProgression();
  }

  @override
  void dispose() {
    resetTimer?.cancel(); // Cancel the timer when HeroModel is disposed
    _debounceTimer?.cancel();
    super.dispose();
  }
}
