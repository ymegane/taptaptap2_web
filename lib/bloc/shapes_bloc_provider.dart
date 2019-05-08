import 'package:flutter_web/widgets.dart';
import 'package:taptaptap2_web/bloc/shapes_bloc.dart';

class ShapesBlocProvider extends InheritedWidget {
  ShapesBlocProvider({
    @required this.bloc,
    @required Widget child,
  }) : super(child: child);

  final ShapesBloc bloc;

  static ShapesBlocProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ShapesBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  
}
