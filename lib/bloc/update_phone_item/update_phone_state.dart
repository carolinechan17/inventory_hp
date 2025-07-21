import 'package:equatable/equatable.dart';

class UpdatePhoneState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;

  const UpdatePhoneState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
  });

  factory UpdatePhoneState.initial() {
    return UpdatePhoneState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
    );
  }

  UpdatePhoneState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
  }) {
    return UpdatePhoneState(
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
