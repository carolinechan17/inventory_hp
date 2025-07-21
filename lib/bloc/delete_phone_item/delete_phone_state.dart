import 'package:equatable/equatable.dart';

class DeletePhoneState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;

  const DeletePhoneState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
  });

  factory DeletePhoneState.initial() {
    return DeletePhoneState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
    );
  }

  DeletePhoneState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
  }) {
    return DeletePhoneState(
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
