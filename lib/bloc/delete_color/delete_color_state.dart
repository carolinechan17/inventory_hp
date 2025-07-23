import 'package:equatable/equatable.dart';

class DeleteColorState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFail;
  final String errorMessage;

  const DeleteColorState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFail,
    required this.errorMessage,
  });

  factory DeleteColorState.initial() {
    return DeleteColorState(
      errorMessage: '',
      isSubmitting: false,
      isSuccess: false,
      isFail: false,
    );
  }

  DeleteColorState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFail,
    String? errorMessage,
  }) {
    return DeleteColorState(
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
