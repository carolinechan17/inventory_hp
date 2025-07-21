import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/add_phone_item/add_phone_event.dart';
import 'package:inventory_hp/bloc/add_phone_item/add_phone_state.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class AddPhoneBloc extends Bloc<AddPhoneEvent, AddPhoneState> {
  AddPhoneBloc()
      : super(
          AddPhoneState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: ''),
        ) {
    on<AddPhone>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        await uploadPhoneItems(event.items);

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
