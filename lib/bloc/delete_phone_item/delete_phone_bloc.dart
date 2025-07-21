import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/delete_phone_item/delete_phone_event.dart';
import 'package:inventory_hp/bloc/delete_phone_item/delete_phone_state.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class DeletePhoneBloc extends Bloc<DeletePhoneEvent, DeletePhoneState> {
  DeletePhoneBloc()
      : super(
          DeletePhoneState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: ''),
        ) {
    on<DeletePhone>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        await deletePhoneItem(event.id);

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
