// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/hero_model.dart';
//
// class QuestTile extends StatefulWidget {
//   final String questName;
//   final String difficulty;
//   final int expReward;
//   final int maxCount;
//   final int currentCount;
//   final VoidCallback onIncrement;
//   final VoidCallback onDecrement;
//
//   const QuestTile({
//     Key? key,
//     required this.questName,
//     required this.difficulty,
//     required this.expReward,
//     required this.maxCount,
//     required this.currentCount,
//     required this.onIncrement,
//     required this.onDecrement,
//   }) : super(key: key);
//
//   @override
//   _QuestTileState createState() => _QuestTileState();
// }
//
// class _QuestTileState extends State<QuestTile> {
//   Timer? _holdTimer;
//   int _lastResetSignal = 0;
//
//   // Start the timer for repeated actions on long press
//   void _startHoldAction(VoidCallback action) {
//     action(); // Perform the action immediately
//     _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       action();
//     });
//   }
//
//   // Stop the timer when the long press ends or on reset
//   void _stopHoldAction() {
//     _holdTimer?.cancel();
//     _holdTimer = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final heroModel = Provider.of<HeroModel>(context);
//
//     // Listen for resetSignal change and stop timer if it changes
//     if (_lastResetSignal != heroModel.resetSignal) {
//       _stopHoldAction();
//       _lastResetSignal = heroModel.resetSignal;
//     }
//
//     bool isCompleted = widget.currentCount >= widget.maxCount;
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: ListTile(
//         title: Text(
//           widget.questName,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Difficulty: ${widget.difficulty}"),
//             Text("exp Reward: ${widget.expReward}"),
//             Text("Progress: ${widget.currentCount} / ${widget.maxCount}"),
//           ],
//         ),
//         trailing: isCompleted
//             ? const Icon(Icons.check, color: Colors.green)
//             : Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onLongPressStart: (_) => _startHoldAction(widget.onDecrement),
//               onLongPressEnd: (_) => _stopHoldAction(),
//               child: IconButton(
//                 icon: const Icon(Icons.remove),
//                 onPressed: widget.currentCount > 0 ? widget.onDecrement : null,
//               ),
//             ),
//             GestureDetector(
//               onLongPressStart: (_) => _startHoldAction(widget.onIncrement),
//               onLongPressEnd: (_) => _stopHoldAction(),
//               child: IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: widget.currentCount < widget.maxCount ? widget.onIncrement : null,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _stopHoldAction(); // Ensure timer is canceled when widget is disposed
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';

class QuestTile extends StatefulWidget {
  final String questName;
  final String difficulty;
  final int expReward;
  final int maxCount;
  final int currentCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int repeatCount;
  final bool isCompleted;
  final bool isRepeatable;

  const QuestTile({
    Key? key,
    required this.questName,
    required this.difficulty,
    required this.expReward,
    required this.maxCount,
    required this.currentCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.repeatCount,
    required this.isCompleted,
    required this.isRepeatable, // Add this parameter
  }) : super(key: key);

  @override
  _QuestTileState createState() => _QuestTileState();
}

class _QuestTileState extends State<QuestTile> {
  Timer? _holdTimer;
  int _lastResetSignal = 0;

  void _startHoldAction(VoidCallback action) {
    action();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      action();
    });
  }

  void _stopHoldAction() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final heroModel = Provider.of<HeroModel>(context);

    if (_lastResetSignal != heroModel.resetSignal) {
      _stopHoldAction();
      _lastResetSignal = heroModel.resetSignal;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          widget.questName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Difficulty: ${widget.difficulty}"),
            Text("EXP Reward: ${widget.expReward}"),
            Text("Progress: ${widget.currentCount} / ${widget.maxCount}"),
            if (widget.isRepeatable)
              Text("Repetitions: ${widget.repeatCount}/10"), // Only for repeatable quests
          ],
        ),
        trailing: widget.isCompleted
            ? const Icon(Icons.check, color: Colors.green)
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onLongPressStart: (_) => _startHoldAction(widget.onDecrement),
              onLongPressEnd: (_) => _stopHoldAction(),
              child: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: widget.currentCount > 0 ? widget.onDecrement : null,
              ),
            ),
            GestureDetector(
              onLongPressStart: (_) => _startHoldAction(widget.onIncrement),
              onLongPressEnd: (_) => _stopHoldAction(),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: !widget.isCompleted && widget.currentCount < widget.maxCount
                    ? widget.onIncrement
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopHoldAction();
    super.dispose();
  }
}
