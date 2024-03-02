import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_app/logic/point.dart';
import 'package:test_app/ui/poligon.dart';

class PolygonPainter extends CustomPainter {
  PolygonPainter(
    this.polygon,
    this.newPoint,
  );
  Polygon polygon;
  Offset? newPoint;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var lines = polygon.lines;

    if (polygon.closed) {
      var paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      var path = Path();
      path.moveTo(polygon.points.first.x, polygon.points.first.y);
      for (var p in polygon.points) {
        path.lineTo(p.x, p.y);
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    var linesPaint = Paint()
      ..color = Colors.black.withAlpha(125)
      ..strokeWidth = 3;
    for (var (p1, p2) in lines) {
      canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), linesPaint);
    }

    for (var p in polygon.points) {
      var center = Offset(p.x, p.y);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 12.5, height: 12.5),
        Paint()..color = const Color.fromARGB(255, 0, 152, 237),
      );
      canvas.drawCircle(
        center,
        6.25,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    if (newPoint != null) {
      canvas.drawOval(
        Rect.fromCenter(center: newPoint!, width: 5, height: 5),
        Paint()..color = Colors.red,
      );

      if (polygon.points.isNotEmpty) {
        var p1 = polygon.points.last;
        var p2 = Point(newPoint!.dx, newPoint!.dy);
        canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), linesPaint);
      }
    }

    var linesLengs = (newPoint == null) || polygon.points.isEmpty
        ? lines
        : lines + [(polygon.points.last, Point(newPoint!.dx, newPoint!.dy))];
    // draw linesLengths
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );
    for (var line in linesLengs) {
      var textSpan = TextSpan(
        text: line.$1.distanceTo(line.$2).roundTo(2).toString(),
        style: textStyle,
      );
      var textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final p = line.$1.getHalfDistancePoint(line.$2);
      final xCenter = p.x + 10;
      final yCenter = p.y;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }
}

extension MyDouble on double {
  /// rounds digit to [n] digits after the point.
  /// n must be > 0
  double roundTo(int n) {
    var d = pow(10, n);
    return (this * d).round() / d;
  }
}
