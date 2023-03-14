import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final double? size;
  final FontWeight? weight;
  final FontStyle? style;
  const AppText({
    super.key,
    required this.text,
    required this.color,
    this.size = 20,
    this.weight = FontWeight.normal,
    this.style = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontStyle: style,
      ),
    );
  }
}
