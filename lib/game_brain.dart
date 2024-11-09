import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hot_n_cold/constants.dart';
import 'package:hot_n_cold/home_page.dart';

class GameBrain {
  final int matrixWidth;
  final int matrixHeight;
  late final Tile _hotTile;

  GameBrain({required this.matrixWidth, required this.matrixHeight}) {
    _hotTile = _generateHotTile();
  }

  int calcDiff(Tile tile) {
    final int xDiff = (tile.x - _hotTile.x).abs();
    final int yDiff = (tile.y - _hotTile.y).abs();
    final int maxDiff = xDiff > yDiff ? xDiff : yDiff;

    return maxDiff;
  }

  Color calcColor(Tile tile) {
    int diff = calcDiff(tile);
    switch (diff) {
      case 0:
        return level1Color;
      case 1:
        return level2Color;
      case 2:
        return level3Color;
      case 3:
        return level4Color;
      case 4:
        return level5Color;
      default:
        return otherLevelColor;
    }
  }

  Tile _generateHotTile() {
    final random = Random();
    final x = random.nextInt(matrixWidth);
    final y = random.nextInt(matrixHeight);
    print('Hot tile: col: ${x + 1}, row: ${y + 1}');
    return Tile(x: x, y: y);
  }

  Tile getHotTile() => _hotTile;

  Matrix getMatrix() {
    return Matrix(
      matrixRowCount: matrixHeight,
      matrixColCount: matrixWidth,
      gameBrain: this,
    );
  }
}

class Matrix {
  final int matrixRowCount;
  final int matrixColCount;
  final GameBrain gameBrain;

  Matrix({
    required this.matrixRowCount,
    required this.matrixColCount,
    required this.gameBrain,
  });

  List<List<Tile>> getMatrixBoard() {
    List<List<Tile>> matrix = [];

    for (var i = 0; i < matrixRowCount; i++) {
      List<Tile> row = [];
      for (var j = 0; j < matrixColCount; j++) {
        row.add(Tile(x: j, y: i));
      }
      matrix.add(row);
    }
    return matrix;
  }

  Widget getMatrixUI() {
    final matrix = getMatrixBoard();
    final player = AudioPlayer();

    return Column(
      children: List.generate(matrixRowCount, (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(matrixColCount, (j) {
            final tile = matrix[i][j];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: TileCard(
                  player: player,
                  tile: tile,
                  color: gameBrain.calcColor(tile),
                  diff: gameBrain.calcDiff(tile),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

class Tile {
  const Tile({required this.x, required this.y});

  final int x;
  final int y;
}

// ignore: must_be_immutable
class TileCard extends StatefulWidget {
  TileCard({
    super.key,
    required this.tile,
    required this.color,
    required this.diff,
    this.title = '',
    required this.player,
  });

  final Tile tile;
  final Color color;
  final int diff;
  String? title;
  final AudioPlayer player;

  @override
  State<TileCard> createState() => _TileCardState();
}

class _TileCardState extends State<TileCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await widget.player.stop();
        if (widget.diff > 0) {
          await widget.player.play(AssetSource(
              'notes/note_${((widget.diff + 1) > 7) ? 7 : (widget.diff + 1)}.wav'));
        }
        setState(() {
          _isPressed = true;
          if (widget.diff == 0) {
            widget.title = 'Hot';
            showWinDialog(context);
          }
        });
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: _isPressed ? widget.color : Colors.teal,
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title ?? '',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showWinDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Congratulations!'),
      content: const Text('You found the hot tile!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Restart the game
            final int matrixWidth =
                Random().nextInt(4) + 4; // Random width between 4-7
            final int matrixHeight =
                Random().nextInt(5) + 4; // Random height between 4-15
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        gameBrain: GameBrain(
                            matrixWidth: matrixWidth,
                            matrixHeight: matrixHeight))));
          },
          child: const Text('Play Again'),
        ),
      ],
    ),
  );
}
