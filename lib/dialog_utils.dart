import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 12,),
                Text(message),
              ],
            ),
          );
        }
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context,
      String message,
      {String title = 'Title',
        String? posActionName,
        VoidCallback? posAction,
        String? negActionName,
        VoidCallback? negAction,
        bool isDismissable = false
      }) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(onPressed: () {
        Navigator.pop(context);
        posAction?.call();
      },
          child: Text(posActionName)
      ));
      if (negActionName != null) {
        actions.add(TextButton(onPressed: () {
          Navigator.pop(context);
          posAction?.call();
        },
            child: Text(negActionName)
        ));
      }
      showDialog(context: context,
          barrierDismissible: isDismissable,
          builder: ((context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: actions,
              titleTextStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18
              ),
            );
          })
      );
    }
  }
}