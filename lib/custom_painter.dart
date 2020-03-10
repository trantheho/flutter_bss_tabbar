import 'package:flutter/cupertino.dart';

class ShapePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    //set color
    paint.color = Color(0xff1E2E90);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path =Path();
    path.moveTo(0, size.height); //A
    path.quadraticBezierTo(size.width * 0.075, size.height * 0.975, size.width * 0.1, size.height * 0.75); // B - C
    path.lineTo(size.width * 0.1255, size.height * 0.3); // D
    path.quadraticBezierTo(size.width * 0.1575, size.height * 0.1, size.width * 0.3, size.height * 0.075); // E - F
    path.lineTo(size.width * (1-0.3), size.height * 0.075); // G
    path.quadraticBezierTo(size.width * (1-0.1575), size.height * 0.1, size.width * (1-0.1255), size.height * 0.3); // H - I
    path.lineTo(size.width * (1-0.1), size.height * 0.75); // K
    path.quadraticBezierTo(size.width * (1 - 0.075), size.height * 0.975, size.width, size.height);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}