import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DeletePhoneEvent extends Equatable {
  DeletePhoneEvent();

  @override
  List<Object?> get props => [];
}

class DeletePhone extends DeletePhoneEvent {
  int id;
  VoidCallback onSuccess;
  Function(String) onFail;

  DeletePhone(
      {required this.id, required this.onFail, required this.onSuccess});

  @override
  List<Object?> get props => [id, onFail, onSuccess];
}
