import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Kennzeichen {
  Kennzeichen({required this.short, required this.long, required this.display});

  final String short;
  final String long;
  final ListTile display;
}

