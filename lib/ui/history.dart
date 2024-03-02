import 'package:test_app/logic/point.dart';

abstract class HistoryEvent {}

class CreatePointEvent extends HistoryEvent {
  Point point;
  CreatePointEvent(this.point);
}

class History {
  List<HistoryEvent> events = [];
  List<HistoryEvent> removedEvents = [];

  History.fromOld(this.events, this.removedEvents);
  History();

  History addEvent(HistoryEvent event) {
    removedEvents.clear();

    events.add(event);
    print(events);
    return this;
  }

  HistoryEvent? removeEvent() {
    if (events.isNotEmpty) {
      removedEvents.add(events.last);
      events.removeLast();
      return removedEvents.last;
    }
    return null;
  }

  HistoryEvent? returnEvent() {
    if (removedEvents.isNotEmpty) {
      events.add(removedEvents.last);
      removedEvents.removeLast();
      return events.last;
    }
    return null;
  }

  bool get isEmpty => events.isEmpty;
  bool get isNotEmpty => !isEmpty;
  bool get canReturn => removedEvents.isNotEmpty;
}
