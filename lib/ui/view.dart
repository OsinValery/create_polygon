import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/logic/manager/view_model.dart';
import 'package:test_app/logic/model/point.dart';

import 'polygon_painter.dart';

class PointsView extends ConsumerWidget {
  const PointsView({super.key});

  void cancelEvent(WidgetRef ref) =>
      ref.read(viewModelProvider.notifier).cancelEvent();

  void returnEvent(WidgetRef ref) =>
      ref.read(viewModelProvider.notifier).returnEvent();

  @override
  Widget build(BuildContext context, ref) {
    var viewModel = ref.watch(viewModelProvider);

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
            var p = details.globalPosition;
            ref.read(viewModelProvider.notifier).setNewPoint(Point(p.dx, p.dy));
          },
          onPanDown: (details) {
            var p = details.globalPosition;
            ref.read(viewModelProvider.notifier).setNewPoint(Point(p.dx, p.dy));
          },
          onPanEnd: (details) {
            ref.read(viewModelProvider.notifier).finishNewPointMovement();
          },
          child: Container(
            color: Colors.white.withAlpha(1),
            child: CustomPaint(
              painter: PolygonPainter(viewModel.polygon, viewModel.newPoint),
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
                      disabled: viewModel.canCancelEvent,
                      onPress: () => cancelEvent(ref)),
                  ToolButton(
                      icon: const Icon(Icons.arrow_forward),
                      disabled: !viewModel.canReturnEvent,
                      onPress: () => returnEvent(ref)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!viewModel.polygon.closed)
                    Container(
                      decoration: decoration,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(8),
                      child: const Center(
                          child: Text(
                              "Нажмите на экран для создания новой точки")),
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
