import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_event.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_state.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class FetchColorBloc extends Bloc<FetchColorEvent, FetchColorState> {
  FetchColorBloc()
      : super(
          FetchColorState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: '',
              colors: [],
              isUpdating: false),
        ) {
    on<HandleAddColor>((event, emit) {
      emit(state.copyWith(isUpdating: true));
      final temp = state.colors;
      temp.add(event.data);

      emit(state.copyWith(colors: temp, isUpdating: false));
    });

    on<GetColors>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        final response = await fetchAllPhoneColors();

        emit(state.copyWith(
            isSuccess: true,
            isSubmitting: false,
            isFail: false,
            colors: response));
      } catch (error) {
        emit(state.copyWith(
            isFail: true,
            isSubmitting: false,
            isSuccess: false,
            errorMessage: error.toString()));
      }
    });
  }
}
