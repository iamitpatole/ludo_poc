import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludo_poc/dice/blue_dice.dart';
import 'package:ludo_poc/dice/green_dice.dart';
import 'package:ludo_poc/dice/red_dice.dart';
import 'package:ludo_poc/dice/yellow_dice.dart';
import 'package:ludo_poc/providers/dice_turn.dart';
import 'package:ludo_poc/widgets/ludo_arena.dart';
import 'package:provider/provider.dart';

import 'providers/dice_model.dart';
import 'providers/game_state.dart';
import 'widgets/dice.dart';

void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GameState()),
            ChangeNotifierProvider(create: (context) => DiceModel()),
            ChangeNotifierProvider(create: (context) => DiceTurn()),
          ],
          child: const _MyHomePage(
            title: 'Flutter Demo Home Page',
            key: null,
          )),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  GlobalKey keyBar = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        key: keyBar,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [GreenDice(), YellowDice()],
          ),
          LudoArena(keyBar, gameState),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [RedDice(), BlueDice()],
          ),
        ],
      ),
    );
  }
}
