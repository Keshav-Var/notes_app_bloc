import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

SnackBar Function(String msg) snackBar = (String msg) => SnackBar(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.startToEnd,
      margin: const EdgeInsets.all(10),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            size: 18.0,
          )
        ],
      ),
    );
