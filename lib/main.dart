import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ludo_poc/dice/blue_dice.dart';
import 'package:ludo_poc/dice/green_dice.dart';
import 'package:ludo_poc/dice/red_dice.dart';
import 'package:ludo_poc/dice/yellow_dice.dart';
import 'package:ludo_poc/widgets/ludo_arena.dart';
import 'package:provider/provider.dart';

import 'providers/dice_model.dart';
import 'providers/game_user_status.dart';
import 'providers/game_state.dart';
import 'utility/firestoredb.dart';

Future<void> main() async {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GameState()),
            ChangeNotifierProvider(create: (context) => DiceModel()),
          ],
          child: const _MyHomePage(
            title: 'Flame',
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
  
  late StreamSubscription _dailySpecialStream;

  @override
  void initState() {
    _activateListener();
    userIds = [123,789,456,678];  
    detectDiceUserId();
    GameUserStatus.updateInitialStatusOfUser(userIds);    
    GameUserStatus.updateUserStatus(assignableUserIds[0], true, false);
    super.initState();
  }

  @override
  void deactivate() {
    _dailySpecialStream.cancel();
    super.deactivate();
  }

  void _activateListener() {
    _dailySpecialStream = FireStoreDB.collectionReference.doc('matchid123').snapshots().listen((querySnapshot) {
      GameUserStatus.updateUserStatusMap(querySnapshot.data() as Map);
    });
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
      backgroundColor: Colors.blue.shade300,
      appBar: AppBar(
        key: keyBar,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [GreenDice(assignableUserIds[1]),Text('${assignableUserIds[1]}'), const Spacer(), YellowDice(assignableUserIds[2]), Text('${assignableUserIds[2]}')],
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
