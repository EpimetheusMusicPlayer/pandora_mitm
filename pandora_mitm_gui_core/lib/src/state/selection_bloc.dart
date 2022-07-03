import 'package:bloc/bloc.dart';

/// A BLoC to keep consistent selections across plugin UIs.
class SelectionBloc extends Cubit<String?> {
  SelectionBloc() : super(null);

  void select(String apiMethod) => emit(apiMethod);
}
