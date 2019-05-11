import 'dart:math';
import 'dart:web_audio';

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

  final AudioContext _audioContext = AudioContext();
  final List<AudioBuffer> _soundEffects = <AudioBuffer>[];

  @override
  void initState() {
    super.initState();

    _loadEffectSounds(context).then((List<AudioBuffer> effects) {
      _soundEffects.addAll(effects);
    });

    _soundController = PublishSubject<ShapesBloc>();
    _soundController
        .throttle(Duration(milliseconds: 2000))
        .listen((ShapesBloc bloc) {
      _playEffect();
    });
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

  Future<List<AudioBuffer>> _loadEffectSounds(BuildContext context) async {
    final AudioBuffer sound1 = await rootBundle
        .load('ani_ge_chicken_koke03.mp3')
        .then((ByteData soundData) {
      return _audioContext.decodeAudioData(soundData.buffer);
    });
    final AudioBuffer sound2 = await rootBundle
        .load('ani_ge_dog_wan01.mp3')
        .then((ByteData soundData) {
      return _audioContext.decodeAudioData(soundData.buffer);
    });
    final AudioBuffer sound3 =
        await rootBundle.load('ani_ge_horse01.mp3').then((ByteData soundData) {
      return _audioContext.decodeAudioData(soundData.buffer);
    });
    final AudioBuffer sound4 =
        await rootBundle.load('ani_ge_owl02.mp3').then((ByteData soundData) {
      return _audioContext.decodeAudioData(soundData.buffer);
    });
    final AudioBuffer sound5 =
        await rootBundle.load('ani_ge_ushi02.mp3').then((ByteData soundData) {
      return _audioContext.decodeAudioData(soundData.buffer);
    });
    final AudioBuffer sound6 =
        await rootBundle.load('ani_ge_flog03.mp3').then((ByteData soundData) {
      return _audioContext.decodeAudioData(soundData.buffer);
    });
    return <AudioBuffer>[sound1, sound2, sound3, sound4, sound5, sound6];
  }

  final Random random = Random.secure();
  Future<void> _playEffect() async {
    if (_soundEffects.isEmpty) {
      return;
    }
    final AudioBuffer audioBuffer =
        _soundEffects[random.nextInt(_soundEffects.length)];

    _audioContext.createBufferSource()
      ..buffer = audioBuffer
      ..connectNode(_audioContext.destination)
      ..start(0);
  }
}
