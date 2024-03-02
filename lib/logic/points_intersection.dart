import 'dart:math';

/// line 1  - point[p1] to point [p2],
///  lin3 2 - point [p3] to point [p4]
bool linesIntersects(Point p1, Point p2, Point p3, Point p4) {
  if (p2.x < p1.x) (p1, p2) = (p2, p1);
  if (p4.x < p3.x) (p4, p3) = (p3, p4);

  return false;
}
