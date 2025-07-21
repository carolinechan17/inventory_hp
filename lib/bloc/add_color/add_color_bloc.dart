import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/add_color/add_color_event.dart';
import 'package:inventory_hp/bloc/add_color/add_color_state.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class AddColorBloc extends Bloc<AddColorEvent, AddColorState> {
  AddColorBloc()
      : super(
          AddColorState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: ''),
        ) {
    on<AddColor>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        final response = await addPhoneColor(event.color);

        emit(state.copyWith(
            isSuccess: true, isSubmitting: false, isFail: false));

        event.onSuccess(response);
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
