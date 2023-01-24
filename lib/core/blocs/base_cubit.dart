import 'package:bloc/bloc.dart';

import 'base_states.dart';

abstract class BlueBotBaseCubit<T extends BlueBotBaseState> extends Cubit<T> {
  BlueBotBaseCubit(T state) : super(state);

  /// Super.emit throws exception on [isClosed].
  /// This override suppresses the exception with early return.
  @override
  void emit(T state) {
    if (isClosed) return;
    super.emit(state);
  }
}
