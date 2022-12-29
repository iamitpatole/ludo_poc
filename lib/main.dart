import 'package:flutter/material.dart';
import 'package:ludo_poc/dice/blue_dice.dart';
import 'package:ludo_poc/dice/green_dice.dart';
import 'package:ludo_poc/dice/red_dice.dart';
import 'package:ludo_poc/dice/yellow_dice.dart';
import 'package:ludo_poc/widgets/ludo_arena.dart';
import 'package:provider/provider.dart';

import 'providers/dice_model.dart';
import 'providers/free_turn.dart';
import 'providers/game_state.dart';

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
  var userIds = <int>[];
  var assignableUserIds = <int>[0,0,0,0];

  @override
  void initState() {
    userIds = [123,789,456,678];  
    detectDiceUserId();
    FreeTurn.updateFreeTurn(assignableUserIds[0], true);
    super.initState();
  }

  detectDiceUserId() {
    int loggedInUserIdIndex = userIds.indexOf(678);
    if(loggedInUserIdIndex == 0) {
      assignableUserIds = userIds;
    }
    if(loggedInUserIdIndex == 1) {
      assignableUserIds[0] = userIds[loggedInUserIdIndex];
      assignableUserIds[1] = userIds[2];
      assignableUserIds[2] = userIds[3];
      assignableUserIds[3] = userIds[0];
    }
    if(loggedInUserIdIndex == 2) {
      assignableUserIds[0] = userIds[loggedInUserIdIndex];
      assignableUserIds[1] = userIds[3];
      assignableUserIds[2] = userIds[0];
      assignableUserIds[3] = userIds[1];
    }
    if(loggedInUserIdIndex == 3) {
      assignableUserIds[0] = userIds[loggedInUserIdIndex];
      assignableUserIds[1] = userIds[0];
      assignableUserIds[2] = userIds[1];
      assignableUserIds[3] = userIds[2];
    }
  }

  GlobalKey keyBar = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    gameState.setAssinableUserId(assignableUserIds);
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
            children: [GreenDice(assignableUserIds[1]),Text('${assignableUserIds[1]}'), Spacer(), YellowDice(assignableUserIds[2]), Text('${assignableUserIds[2]}')],
          ),
          LudoArena(keyBar, gameState),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [RedDice(assignableUserIds[0]),Text('${assignableUserIds[0]}'),Spacer(), BlueDice(assignableUserIds[3]),Text('${assignableUserIds[3]}')],
          ),
        ],
      ),
    );
  }
}
