import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    if (state < 20) {
      emit(state + 1);
    } else {
      Fluttertoast.showToast(
        msg: 'Alcanzaste el maximo',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void decrement() {
    if (state > -20) {
      emit(state - 1);
    } else {
      Fluttertoast.showToast(
        msg: 'Llegaste al minimo',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void reset() {
    emit(0);
  }
}
