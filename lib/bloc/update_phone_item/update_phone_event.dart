import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UpdatePhoneEvent extends Equatable {
  UpdatePhoneEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePhone extends UpdatePhoneEvent {
  List<Map<String, dynamic>> items;
  VoidCallback onSuccess;
  Function(String) onFail;

  UpdatePhone(
      {required this.items, required this.onFail, required this.onSuccess});

  @override
  List<Object?> get props => [items, onFail, onSuccess];
}

class UpdateOnePhone extends UpdatePhoneEvent {
  Map<String, dynamic> item;
  VoidCallback onSuccess;
  Function(String) onFail;

  UpdateOnePhone(
      {required this.item, required this.onFail, required this.onSuccess});

  @override
  List<Object?> get props => [item, onFail, onSuccess];
}
