import 'dart:math' show sqrt, pow;

class Point {
  double x;
  double y;
  Point(this.x, this.y);

  double distanceTo(Point second) =>
      sqrt(pow(second.x - x, 2) + pow(second.y - y, 2));

  Point getHalfDistancePoint(Point other) {
    return Point((other.x + x) / 2, (other.y + y) / 2);
  }
}
