import 'package:test_app/logic/model/point.dart';

class Polygon {
  List<Point> points = [];
  bool closed = false;

  void addPoint(Point point) {
    if (closed) return;
    points.add(point);
  }

  void checkOnClose({double distance = 20}) {
    if ((points.length < 3) || closed) return;
    if (points.last.distanceTo(points.first) < distance) {
      closed = true;
    }
  }

  void removePoint() {
    if (points.isNotEmpty) {
      points.removeLast();
      closed = false;
    }
  }

  bool get hasLines => points.length > 1;
  int get countLines => points.length - 1;
  List<(Point, Point)> get lines {
    if (!hasLines) return [];
    List<(Point, Point)> result = [];
    for (var i = 0; i < countLines; i++) {
      result.add((points[i], points[i + 1]));
    }
    if (closed) result.add((points.first, points.last));
    return result;
  }
}
