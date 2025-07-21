import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_event.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_state.dart';
import 'package:inventory_hp/data/model/phone_item.dart';
import 'package:inventory_hp/data/service/phone_services.dart';

class FetchPhoneBloc extends Bloc<FetchPhoneEvent, FetchPhoneState> {
  FetchPhoneBloc()
      : super(
          FetchPhoneState(
              isSubmitting: false,
              isSuccess: false,
              isFail: false,
              errorMessage: '',
              items: [],
              isUpdating: false,
              searchResults: []),
        ) {
    on<SearchPhones>((event, emit) {
      if (event.query.isEmpty) {
        emit(state.copyWith(searchResults: state.items));
        return;
      }

      final temp = state.items;
      List<PhoneItem> result = temp.where((item) {
        final query = event.query.trim().toLowerCase();
        final nameMatches = item.name?.toLowerCase().contains(query) ?? false;
        final colorMatches = item.color?.toLowerCase().contains(query) ?? false;
        return nameMatches || colorMatches;
      }).toList();

      emit(state.copyWith(searchResults: result));
    });

    on<HandleAddPhones>((event, emit) {
      emit(state.copyWith(isUpdating: true));
      final temp = state.items;
      temp.addAll(event.data);
      emit(state.copyWith(items: temp, isUpdating: false));
    });

    on<GetPhones>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, isFail: false, isSuccess: false));

      try {
        final response = await fetchAllPhoneItems();

        emit(state.copyWith(
            isSuccess: true,
            isSubmitting: false,
            isFail: false,
            items: response));
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
