import 'package:flutter/material.dart';

class ScaledDraggable<DragDataType extends Object> extends StatelessWidget {
  final Widget child;
  final DragDataType dragData;

  const ScaledDraggable({
    required this.dragData,
    required this.child,
    super.key,
  });

  @override
  build(context) {
    late final feedback = SizedBox.fromSize(
      size: (context.findRenderObject() as RenderBox).size,
      child: child,
    );

    return Draggable(
      feedback: Builder(builder: (context) => feedback),
      data: dragData,
      childWhenDragging: Visibility(
        maintainSize: true,
        maintainState: true,
        maintainAnimation: true,
        visible: false,
        child: child,
      ),
      child: child,
    );
  }
}
