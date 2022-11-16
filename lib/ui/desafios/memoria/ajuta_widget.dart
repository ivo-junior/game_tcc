import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

class Ajuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // height: double.infinity,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      color: Color(0xffaaffee),
      child: PhotoView(
        imageProvider: AssetImage("assets/ajuda.jpg"),
      ),
      // child: SvgPicture.asset(
      //   'assets/ajuda.svg',
      //   fit: BoxFit.fitWidth,
      //   alignment: Alignment.bottomCenter,
      // ),
    );
  }
}
