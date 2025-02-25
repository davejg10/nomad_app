// Extension created for the AsyncValue type so we can easily reference Riverpod state and log a message of the error and display it as a snackbar on the screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar(String message)
      : super(
    content: Text(
      message,
      style: TextStyle(
          fontSize: 20, fontFamily: "DMSans-Regular.ttf"),
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
  );
}


extension AsyncValueUI on AsyncValue {

  void showSnackbarOnError(BuildContext context, Logger logger) {
    if (!isLoading && hasError) {
      logger.e(error);
      logger.e(stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackbar(error.toString())
      );
    }
  }
}