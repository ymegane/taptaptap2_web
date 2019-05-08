import 'package:flutter_web/gestures.dart';
import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taptaptap2_web/bloc/shapes_bloc.dart';
import 'package:taptaptap2_web/bloc/shapes_bloc_provider.dart';
import 'package:taptaptap2_web/widget/shape_widget.dart';

class Playground extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  PublishSubject<DragUpdateDetails> _moveEvents;
  PublishSubject<ShapesBloc> _soundController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ShapesBloc bloc = ShapesBlocProvider.of(context).bloc;
    _moveEvents = PublishSubject<DragUpdateDetails>();
    _moveEvents
        .throttle(Duration(milliseconds: 100))
        .listen((DragUpdateDetails details) {
      _handleMove(context, bloc, details);
    });

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
        MultiTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<MultiTapGestureRecognizer>(
                () => MultiTapGestureRecognizer(),
                (MultiTapGestureRecognizer instance) {
          instance.onTapDown = (int pointer, TapDownDetails details) =>
              _handleTap(context, bloc, details);
        }),
        PanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                () => PanGestureRecognizer(), (PanGestureRecognizer instance) {
          instance.onUpdate =
              (DragUpdateDetails details) => _moveEvents.add(details);
        }),
      },
      child: Container(
        color: Colors.white,
        child: StreamBuilder<List<ShapeWidget>>(
          stream: bloc.shapes,
          initialData: bloc.shapes.value,
          builder: (_, AsyncSnapshot<List<ShapeWidget>> snap) => Stack(
                fit: StackFit.expand,
                children: snap.data,
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _moveEvents.close();
    _soundController.close();
    super.dispose();
  }

  void _handleTap(
      BuildContext context, ShapesBloc bloc, TapDownDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    _addCircle(bloc, localOffset);
  }

  void _handleMove(
      BuildContext context, ShapesBloc bloc, DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    _addCircle(bloc, localOffset);
  }

  Future<void> _addCircle(ShapesBloc bloc, Offset offset) async {
    const double circleRadius = ShapeWidget.SIZE / 2;

    bloc.shapeAddition.add(
      ShapeWidget(
        key: UniqueKey(),
        x: offset.dx - circleRadius,
        y: offset.dy - circleRadius,
        bloc: bloc,
      ),
    );
    _soundController.add(bloc);
  }
}
