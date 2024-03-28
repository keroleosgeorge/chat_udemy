import 'package:chat_udemy/utill/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class logoapp extends StatelessWidget {
  const logoapp({super.key});

  @override
  Widget build(BuildContext context) {
    return   SvgPicture.asset(
      "assets/svg.svg",
      height: 150,
      colorFilter: ColorFilter.mode(kprimary, BlendMode.srcIn),
    );
  }
}
