import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

const TILE_SIZE_SPRITE_SHEET = 16;

double valueByTileSize(double value) {
  return value * (tileSize / TILE_SIZE_SPRITE_SHEET);
}

void mgsAlertSnakBar(String msg, BuildContext ct) {
  ScaffoldMessenger.of(ct).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: TextStyle(fontSize: 15, color: Colors.red),
      ),
      action: SnackBarAction(label: 'OK', onPressed: () {}),
    ),
  );
}
