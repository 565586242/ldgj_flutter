import 'dart:convert';

import 'package:flutter/material.dart';

class SeeImagePage extends StatelessWidget {
  final image;
  final type;
  const SeeImagePage({Key key,this.image,this.type}) : super(key: key);

  Widget _getImageWidget() {
    switch (type) {
      case "base64":
        return Image.memory(Base64Decoder().convert(image.split(',')[1]),fit: BoxFit.contain,);
        break;
      case "Uint8List":
        return Image.memory(image,fit: BoxFit.contain,);
        break;
      case "network":
        return Image.network(image,fit: BoxFit.contain,);
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey _globalKey = GlobalKey();

    return Scaffold(
      body: GestureDetector(
        key: _globalKey,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _getImageWidget(),
        ),
      )
    );
  }
}