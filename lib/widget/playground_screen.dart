import 'package:flutter_web/material.dart';
import 'package:taptaptap2_web/bloc/shapes_bloc.dart';
import 'package:taptaptap2_web/bloc/shapes_bloc_provider.dart';
import 'package:taptaptap2_web/util/app_icons.dart';
import 'package:taptaptap2_web/widget/playground.dart';

class PlaygroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShapesBlocProvider(
      bloc: ShapesBloc(),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Playground(),
        ),
        SafeArea(
          child: _buildCloseButton(context),
        )
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        height: 48,
        child: RaisedButton(
          color: Colors.white,
          child: const Icon(AppIcons.close),
          shape: CircleBorder(),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
