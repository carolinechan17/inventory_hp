import 'package:equatable/equatable.dart';
import 'package:inventory_hp/data/model/phone_item.dart';

class FetchPhoneState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;
  final List<PhoneItem> items;
  final bool isUpdating;
  final List<PhoneItem> searchResults;

  const FetchPhoneState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
    required this.items,
    required this.isUpdating,
    required this.searchResults,
  });

  factory FetchPhoneState.initial() {
    return FetchPhoneState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
      items: [],
      isUpdating: false,
      searchResults: [],
    );
  }

  FetchPhoneState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
    List<PhoneItem>? items,
    bool? isUpdating,
    List<PhoneItem>? searchResults,
  }) {
    return FetchPhoneState(
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFail: isFail ?? this.isFail,
      items: items ?? this.items,
      isUpdating: isUpdating ?? this.isUpdating,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object> get props => [
        isSubmitting,
        isSuccess,
        isFail,
        errorMessage,
        items,
        isUpdating,
        searchResults,
      ];
}
