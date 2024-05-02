import 'package:e_kantin/constant.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  final BuildContext context;
  bool _isShowing = false;

  LoadingDialog(this.context);

  void show(String message) {
    if (!_isShowing) {
      _isShowing = true;
      showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
                  ),
                  const SizedBox(width: 16),
                  Text(message),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void hide() {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(context).pop(); // Tutup dialog
    }
  }
}
