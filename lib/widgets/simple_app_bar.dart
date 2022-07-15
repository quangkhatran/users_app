import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom});

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        'iFood',
        style: TextStyle(
          fontSize: 45,
          fontFamily: 'Signatra',
        ),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}
