import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/delete_color/delete_color_event.dart';
import 'package:inventory_hp/bloc/delete_color/delete_color_state.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class DeleteColorBloc extends Bloc<DeleteColorEvent, DeleteColorState> {
  DeleteColorBloc()
      : super(
          DeleteColorState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: ''),
        ) {
    on<DeleteColor>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        await deletePhoneColor(event.id);

        emit(state.copyWith(
            isSuccess: true, isSubmitting: false, isFail: false));

        event.onSuccess();
      } catch (error) {
        emit(state.copyWith(
            isFail: true,
            isSubmitting: false,
            isSuccess: false,
            errorMessage: error.toString()));
        event.onFail(state.errorMessage);
      }
    });
  }
}
