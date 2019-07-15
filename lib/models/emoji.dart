import 'dart:math';
import 'package:memorymap/models/tile.dart';

class EmojiService {
  List<String> emojis = [
    "😀",
    "😁",
    "😂",
    "🤣",
    "😃",
    "😄",
    "😅",
    "😆",
    "😉",
    "😊",
    "😋",
    "😎",
    "😍",
    "😘",
    "😗",
    "😙",
    "😚",
    "🙂",
    "🤗",
    "🤩",
    "🤔",
    "🤨",
    "😐",
    "😑",
    "😶",
    "🙄",
    "😏",
    "😣",
    "😥",
    "😮",
    "🤐",
    "😯",
    "😪",
    "😫",
    "😴",
    "😌",
    "😛",
    "😜",
    "😝",
    "🤤",
    "😒",
    "😓",
    "😔",
    "😕",
    "🙃",
    "🤑",
    "😲",
    "🙁",
    "😖",
    "😞",
    "😟",
    "😤",
    "😢",
    "😭",
    "😦",
    "😧",
    "😨",
    "😩",
    "🤯",
    "😬",
    "😰",
    "😱",
    "😳",
    "🤪",
    "😵",
    "😡",
    "😠",
    "🤬",
    "😷",
    "🤒",
    "🤕",
    "🤢",
    "🤮",
    "🤧",
    "😇",
    "🤠",
    "🤥",
    "🤫",
    "🤭",
    "🧐",
    "🤓",
    "😈",
    "👿",
    "🤡",
    "👹",
    "👺",
    "💀",
    "👻",
    "👽",
    "👾",
    "🤖",
    "💩",
    "😺",
    "😸",
    "😹",
  ];

  Set getCollection(int numberOfItems) {
    // TODO: Check numberOfItems is divisible by 4, for the sake of grid :)
    Set<Tile> emojiSet = new Set<Tile>(); // ensures unique tokens are stored
    Set tempSet = new Set();
    var rand = new Random();
    int i = 1;
    while (emojiSet.length < (numberOfItems / 2)) {
      if (tempSet.add(emojis[rand.nextInt(emojis.length - 1)])) {
        emojiSet.add(Tile(i, tempSet.elementAt(i - 1)));
        i++;
      }
    }

    return emojiSet;
  }
}
