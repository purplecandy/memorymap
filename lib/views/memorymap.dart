import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';

import 'package:memorymap/models/tile.dart';
import 'package:memorymap/blocs/game.dart';

class MemoryMap extends StatefulWidget {
  final GameBLoc _gameBLoc = GameBLoc();
  MemoryMap({Key key}) : super(key: key);

  _MemoryMapState createState() => _MemoryMapState();
}

class _MemoryMapState extends State<MemoryMap>
    with SingleTickerProviderStateMixin {
  GameBLoc get bloc => widget._gameBLoc;

  AnimationController _controller;

  Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red,
        end: Colors.green,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.green,
        end: Colors.blue,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.blue,
        end: Colors.pink,
      ),
    ),
  ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Scaffold(
            backgroundColor:
                background.evaluate(AlwaysStoppedAnimation(_controller.value)),
            appBar: PreferredSize(
              preferredSize: Size(0, 0),
              child: StreamBuilder(
                stream: bloc.gameStatus,
                builder: (context, snap) {
                  if (snap.hasData) {
                    if (snap.data == 'over') {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Game Over !!!'),
                      ));
                    }
                  }
                  return Container();
                },
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.amberAccent,
                        child: Text('START'),
                        onPressed: bloc.start,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      FlatButton(
                        color: Colors.tealAccent,
                        child: Text('RESET'),
                        onPressed: bloc.stop,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StreamBuilder(
                    stream: bloc.tiles,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Tile>> snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          itemCount: bloc.listOfTiles.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: (context, index) {
                            return StreamBuilder(
                              stream: bloc.gameStatus,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> status) {
                                if (status.hasData) {
                                  if (status.data == 'changed') {
                                    return InkWell(
                                      child: Card(
                                        color: bloc.getTileColor(
                                            snapshot.data[index], index),
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Center(
                                            child: Visibility(
                                              visible: bloc.tileVisiblity(
                                                  snapshot.data[index], index),
                                              child: Text(
                                                snapshot.data[index].emoji,
                                                style: TextStyle(fontSize: 32),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        bloc.tileClick(snapshot.data[index],
                                            index, context);
                                      },
                                    );
                                  }
                                  if (status.data == 'reset')
                                    return GameBoard();
                                }
                                return GameBoard();
                              },
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Container(
                  height: 40,
                  child: StreamBuilder(
                    stream: bloc.gameTimer,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              snapshot.data['H'].toString() +
                                  ':' +
                                  snapshot.data['M'].toString() +
                                  ':' +
                                  snapshot.data['S'].toString(),
                              style: TextStyle(
                                  fontFamily: 'Press Start', fontSize: 32),
                            ),
                            // Text(snapshot.data['M'].toString() + ':'),
                            // Text(snapshot.data['S'].toString())
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: SizedBox(
        height: 40,
        width: 40,
      ),
    );
  }
}
