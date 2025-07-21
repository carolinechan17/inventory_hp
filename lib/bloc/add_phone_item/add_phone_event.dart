import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AddPhoneEvent extends Equatable {
  AddPhoneEvent();

  @override
  List<Object?> get props => [];
}

class AddPhone extends AddPhoneEvent {
  List<Map<String, dynamic>> items;
  VoidCallback onSuccess;
  Function(String) onFail;

  AddPhone(
      {required this.items, required this.onFail, required this.onSuccess});

  @override
  List<Object?> get props => [items, onFail, onSuccess];
}
