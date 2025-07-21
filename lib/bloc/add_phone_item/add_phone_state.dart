import 'package:equatable/equatable.dart';

class AddPhoneState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;

  const AddPhoneState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
  });

  factory AddPhoneState.initial() {
    return AddPhoneState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
    );
  }

  AddPhoneState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
  }) {
    return AddPhoneState(
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
