import 'package:flutter/material.dart';

import '../models/token_type.dart';
import '../providers/game_state.dart';
import './board.dart';
import 'tokenp.dart';

class LudoArena extends StatefulWidget {
  final GlobalKey keyBar;
  final GameState gameState;

  const LudoArena(this.keyBar, this.gameState, {super.key});

  @override
  LudoArenaState createState() => LudoArenaState();
}

class LudoArenaState extends State<LudoArena> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((context) {
      setState(() {
        boardBuild = true;
      });
    });
  }
  bool boardBuild = false;
  List<double> dimentions = [0, 0, 0, 0];
  final List<List<GlobalKey>> keyRefrences = _getGlobalKeys();

  static List<List<GlobalKey>> _getGlobalKeys() {
    List<List<GlobalKey>> keysMain = [];
    for (int i = 0; i < 15; i++) {
      List<GlobalKey> keys = [];
      for (int j = 0; j < 15; j++) {
        keys.add(GlobalKey());
      }
      keysMain.add(keys);
    }
    return keysMain;
  }

List<double> _getPosition(int row, int column) {
    var listFrame = <double>[];
    double x, y, w, h;
    if (widget.keyBar.currentContext == null) return [0, 0, 0, 0];
    final cellBoxKey = keyRefrences[row][column];
    final RenderBox renderBoxCell =
        cellBoxKey.currentContext!.findRenderObject()! as RenderBox;
    final positionCell = renderBoxCell.localToGlobal(Offset.zero);
    x = positionCell.dx;
    y = positionCell.dy - 250;
    w = renderBoxCell.size.width;
    h = renderBoxCell.size.height;
    listFrame.add(x);
    listFrame.add(y);
    listFrame.add(w);
    listFrame.add(h);
    return listFrame;
  }

  List<Tokenp> _getTokenList() {
    List<Tokenp> widgets = [];
    for (Token token in widget.gameState.gameTokens) {
      widgets.add(Tokenp(token,
          _getPosition(token.tokenPosition.row, token.tokenPosition.column)));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Board(keyRefrences),
      ..._getTokenList(),
    ]);
  }
}
