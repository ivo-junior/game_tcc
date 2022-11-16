import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatefulWidget {
  final NetworkImage myImage;
  final String initials;

  CustomCircleAvatar({required this.myImage, required this.initials});

  @override
  _CustomCircleAvatarState createState() => new _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  bool _checkLoading = true;

  @override
  void initState() {
    super.initState();
    widget.myImage
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoading = false;
        });
      }
    })
            /*
    */
            );
  }

  @override
  Widget build(BuildContext context) {
    return _checkLoading == true
        ? new CircleAvatar(child: new Text(widget.initials))
        : new Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: widget.myImage,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    repeat: ImageRepeat.noRepeat)),
          );
  }
}
