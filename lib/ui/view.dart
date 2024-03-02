import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/logic/point.dart';

import 'package:test_app/ui/history.dart';
import 'package:test_app/ui/poligon.dart';
import 'polygon_painter.dart';

var historyProvider = StateProvider((ref) => History());
var polygonProvider = StateProvider((ref) => Polygon());
var newPointProvider = StateProvider<Offset?>((ref) => null);

class PointsView extends ConsumerWidget {
  const PointsView({super.key});

  void cancelEvent(WidgetRef ref) {
    var event = ref.read(historyProvider.notifier).state.removeEvent();

    if (event is CreatePointEvent) {
      ref.read(polygonProvider.notifier).state.removePoint();
    }

    var history = ref.read(historyProvider);
    ref.read(historyProvider.notifier).state =
        History.fromOld(history.events, history.removedEvents);
  }

  void returnEvent(WidgetRef ref) {
    var event = ref.read(historyProvider.notifier).state.returnEvent();

    if (event is CreatePointEvent) {
      var pol = ref.read(polygonProvider.notifier).state;
      pol.addPoint(event.point);
      pol.checkOnClose();
    }

    var history = ref.read(historyProvider);
    ref.read(historyProvider.notifier).state =
        History.fromOld(history.events, history.removedEvents);
  }

  @override
  Widget build(BuildContext context, ref) {
    var history = ref.watch(historyProvider);
    var polygon = ref.watch(polygonProvider);
    var newPoint = ref.watch(newPointProvider);

    var decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
    );
    return Scaffold(
      body: Stack(children: [
        Container(
          color: const Color.fromARGB(255, 220, 220, 220),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            ref.read(newPointProvider.notifier).state = details.globalPosition;
          },
          onPanDown: (details) {
            ref.read(newPointProvider.notifier).state = details.globalPosition;
          },
          onPanEnd: (details) {
            var p = newPoint!;
            var np = Point(p.dx, p.dy);

            ref.read(polygonProvider.notifier).state.addPoint(np);
            polygon.checkOnClose();

            var history = ref.read(historyProvider);
            history.addEvent(CreatePointEvent(np));
            ref.read(historyProvider.notifier).state =
                History.fromOld(history.events, history.removedEvents);

            ref.read(newPointProvider.notifier).state = null;
          },
          child: Container(
            color: Colors.white.withAlpha(1),
            child: CustomPaint(
              painter: PolygonPainter(polygon, newPoint),
              child: Container(),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ToolButton(
                      icon: const Icon(Icons.arrow_back),
                      disabled: history.isEmpty,
                      onPress: () => cancelEvent(ref)),
                  ToolButton(
                      icon: const Icon(Icons.arrow_forward),
                      disabled: !history.canReturn,
                      onPress: () => returnEvent(ref)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: decoration,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(8),
                    child: const Center(
                        child:
                            Text("Нажмите на экран для создания новой точки")),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    decoration: decoration,
                    padding: const EdgeInsets.all(12),
                    child: CancelButton(onPress: () => cancelEvent(ref)),
                  )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key, required this.onPress});

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 227, 227, 227),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Text(
                "x",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Text(
              "Отменить действие",
              style: TextStyle(color: Color.fromARGB(255, 86, 84, 84)),
            )
          ],
        ),
      ),
    );
  }
}

class ToolButton extends StatelessWidget {
  const ToolButton(
      {super.key,
      required this.icon,
      required this.disabled,
      required this.onPress});

  final Function() onPress;
  final Widget icon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: IconButton(
        icon: icon,
        onPressed: disabled ? null : onPress,
      ),
    );
  }
}
