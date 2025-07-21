import 'package:equatable/equatable.dart';
import 'package:inventory_hp/data/model/phone_color.dart';

class FetchColorState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;
  final List<PhoneColor> colors;
  final bool isUpdating;

  const FetchColorState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
    required this.colors,
    required this.isUpdating,
  });

  factory FetchColorState.initial() {
    return FetchColorState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
      colors: [],
      isUpdating: false,
    );
  }

  FetchColorState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
    List<PhoneColor>? colors,
    bool? isUpdating,
  }) {
    return FetchColorState(
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFail: isFail ?? this.isFail,
      colors: colors ?? this.colors,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object> get props => [
        isSubmitting,
        isSuccess,
        isFail,
        errorMessage,
        colors,
        isUpdating,
      ];
}
