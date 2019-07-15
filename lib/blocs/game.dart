import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:memorymap/models/tile.dart';
import 'package:memorymap/models/emoji.dart';
import 'dart:core';

enum GameStatus { running, over, notstarted }

class GameBLoc {
  bool gameStarted = false;
  GameStatus cgameStatus = GameStatus.notstarted;

  Tile lastActive;
  int lastIndex = 0;

  Map<String, dynamic> timer = {
    'H': 0,
    'M': 0,
    'S': 0,
  };
  PublishSubject<Map<String, dynamic>> _subjectTimer;

  List<Tile> listOfTiles = [];
  BehaviorSubject<List<Tile>> _subjectListOfTiles;

  List<int> listOfRevealedTiles = [];
  // BehaviorSubject<List<int>> _subjectListOfRevealedTiles;
  PublishSubject<List<int>> _subjectListOfRevealedTiles;

  List<Map<String, dynamic>> activeTileCounter = [];
  PublishSubject<Map<String, dynamic>> _subjectactiveTileCounter;

  PublishSubject<String> _subjectGameStatus;

  GameBLoc() {
    List<Tile> emojiset =
        EmojiService().getCollection(16).toList(growable: true);
    listOfTiles.addAll(emojiset);
    listOfTiles.addAll(emojiset);
    listOfTiles.shuffle();

    _subjectTimer = PublishSubject<Map<String, dynamic>>();
    _subjectListOfTiles = BehaviorSubject.seeded(listOfTiles);
    _subjectListOfRevealedTiles = PublishSubject<List<int>>();
    _subjectGameStatus = PublishSubject<String>();
    _subjectTimer.add(timer);
  }

  Observable<List<Tile>> get tiles => _subjectListOfTiles.stream;
  Observable<List<int>> get revealedtiles => _subjectListOfRevealedTiles.stream;
  Observable<String> get gameStatus => _subjectGameStatus.stream;
  Observable<Map<String, dynamic>> get gameTimer => _subjectTimer.stream;

  void start() {
    if (gameStarted != true) {
      gameStarted = true;
      cgameStatus = GameStatus.running;
      _subjectGameStatus.add('changed');
      loopTimer();
    }
  }

  void stop() {
    gameStarted = false;
    cgameStatus = GameStatus.notstarted;
    loopTimer();
    _subjectGameStatus.add('reset');
    listOfTiles = [];
    listOfRevealedTiles = [];
    activeTileCounter = [];
    lastIndex = 0;
    List<Tile> emojiset =
        EmojiService().getCollection(16).toList(growable: true);
    listOfTiles.addAll(emojiset);
    listOfTiles.addAll(emojiset);
    listOfTiles.shuffle();
    _subjectListOfTiles.add(listOfTiles);
    _subjectTimer.add(timer);
  }

  void loopTimer() {
    if (gameStarted == true && cgameStatus == GameStatus.running) {
      Timer(Duration(seconds: 1), () {
        timer['S']++;
        if (timer['S'] >= 60) {
          timer['S'] = 0;
          timer['M']++;
          if (timer['M'] > 59) {
            timer['H']++;
            timer['M'] = 0;
          }
        }
        _subjectTimer.add(timer);
        print(timer);
        loopTimer();
      });
    } else {
      // if(gameStarted !=true && cgameStatus == GameStatus.over){

      // }
      if (gameStarted != true && cgameStatus == GameStatus.notstarted) {
        timer = {
          'H': 0,
          'M': 0,
          'S': 0,
        };
        _subjectTimer.add(timer);
      }
    }
  }

  Color getTileColor(Tile tile, int index) {
    if (listOfRevealedTiles.contains(tile.id)) {
      return Colors.greenAccent;
    } else {
      for (var item in activeTileCounter) {
        if (index == item['index']) {
          return Colors.lightBlueAccent;
        }
      }
      return Colors.grey;
    }
  }

  bool tileVisiblity(Tile tile, int index) {
    if (getTileColor(tile, index) == Colors.grey) {
      return false;
    } else {
      return true;
    }
  }

  void tileClick(Tile currentTile, int index, BuildContext context) async {
    if (activeTileCounter.length == 0) {
      lastIndex = index;
      activeTileCounter.add({'id': currentTile.id, 'index': index});
      lastActive = currentTile;
    } else if (activeTileCounter.length == 1 && index != lastIndex) {
      activeTileCounter.add({'id': currentTile.id, 'index': index});
      _subjectGameStatus.add('changed');
      await Future.delayed(Duration(milliseconds: 300), () {
        if (lastActive.id == currentTile.id) {
          listOfRevealedTiles.add(lastActive.id);
          _subjectListOfRevealedTiles.add(listOfRevealedTiles);
          activeTileCounter = [];
        } else {
          activeTileCounter = [];
        }
      });
    }
    if (listOfRevealedTiles.length == listOfTiles.length / 2) {
      cgameStatus = GameStatus.over;
      _subjectGameStatus.add('changed');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Game Over !!!'),
      ));
    } else {
      _subjectGameStatus.add('changed');
    }
  }

  void dispose() {
    _subjectactiveTileCounter.close();
    _subjectListOfRevealedTiles.close();
    _subjectListOfTiles.close();
  }
}
