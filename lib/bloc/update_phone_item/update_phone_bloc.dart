import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_event.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_state.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class UpdatePhoneBloc extends Bloc<UpdatePhoneEvent, UpdatePhoneState> {
  UpdatePhoneBloc()
      : super(
          UpdatePhoneState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: ''),
        ) {
    on<UpdatePhone>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        await updatePhoneItems(event.items);

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

    on<UpdateOnePhone>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        await updateOnePhoneItem(event.item);

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
