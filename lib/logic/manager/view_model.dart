import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/logic/model/history.dart';
import 'package:test_app/logic/model/point.dart';
import 'package:test_app/logic/model/poligon.dart';

final viewModelProvider = ChangeNotifierProvider((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _polygon = Polygon();
  final _history = History();
  Point? newPoint;

  Polygon get polygon => _polygon;
  bool get canCancelEvent => _history.isEmpty;
  bool get canReturnEvent => _history.canReturn;
  static const polygonCloseDistance = 30.0;

  void cancelEvent() {
    var event = _history.removeEvent();

    if (event is CreatePointEvent) {
      polygon.removePoint();
    }

    notifyListeners();
  }

  void returnEvent() {
    var event = _history.returnEvent();

    if (event is CreatePointEvent) {
      _polygon.addPoint(event.point);
      _polygon.checkOnClose(distance: polygonCloseDistance);
    }

    notifyListeners();
  }

  void setNewPoint(Point? point) {
    newPoint = point;
    notifyListeners();
  }

  void finishNewPointMovement() {
    _polygon.addPoint(newPoint!);
    _polygon.checkOnClose(distance: polygonCloseDistance);
    _history.addEvent(CreatePointEvent(newPoint!));
    newPoint = null;
    notifyListeners();
  }
}
