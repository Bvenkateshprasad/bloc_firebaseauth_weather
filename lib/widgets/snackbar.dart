import 'package:flutter/material.dart';

var cityName = "Bengaluru";
snackbar(context, text) {
  RegExp regex = RegExp(r'\[.*?\]');
  String textOutsideBrackets = text.replaceAll(regex, '').trim();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    width: MediaQuery.of(context).size.width * 0.8,
    behavior: SnackBarBehavior.floating,
    content: Center(
      child: Text(textOutsideBrackets,
          style: const TextStyle(color: Colors.black)),
    ),
    backgroundColor: Colors.amber,
  ));
}
