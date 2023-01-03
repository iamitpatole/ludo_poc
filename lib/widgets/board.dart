import 'package:flutter/material.dart';

import 'ludo_row.dart';

class Board extends StatelessWidget {
  final List<List<GlobalKey>> keyRefrences;

  const Board(this.keyRefrences, {super.key});

  List<Container> _getRows() {
    
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: const BorderSide(color: Colors.grey),
              bottom: i == 14
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
            ),
            color: Colors.transparent,
          ),
          child: LudoRow(i, keyRefrences[i]),
          //child: Text('${i}'),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ludo_board_original.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(children: [..._getRows()]),
        ),
      ),
    );
  }
}
