import 'package:equatable/equatable.dart';

class AddColorState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;

  const AddColorState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
  });

  factory AddColorState.initial() {
    return AddColorState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
    );
  }

  AddColorState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
  }) {
    return AddColorState(
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFail: isFail ?? this.isFail,
    );
  }

  @override
  List<Object> get props => [
        isSubmitting,
        isSuccess,
        isFail,
        errorMessage,
      ];
}
