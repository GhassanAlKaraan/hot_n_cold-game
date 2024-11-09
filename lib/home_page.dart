import 'package:flutter/material.dart';
import 'package:hot_n_cold/constants.dart';
import 'package:hot_n_cold/game_brain.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.gameBrain});

  final GameBrain? gameBrain;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GameBrain _gameBrain;

  @override
  void initState() {
    if (widget.gameBrain != null) {
      _gameBrain = widget.gameBrain!;
    } else {
      _gameBrain = GameBrain(matrixWidth: 5, matrixHeight: 6);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const Text(
                'Find the Hot Tile!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _gameBrain.getMatrix().getMatrixUI(),
            ],
          ),
        ),
      ),
    );
  }
}
