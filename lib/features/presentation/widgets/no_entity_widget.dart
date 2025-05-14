import 'package:flutter/material.dart';

class NoEntityWidget extends StatelessWidget {
  const NoEntityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/notebook.png"),
            height: 120,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No notess here yet",
          ),
        ],
      ),
    );
  }
}
