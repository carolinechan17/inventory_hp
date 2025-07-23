import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DeleteColorEvent extends Equatable {
  DeleteColorEvent();

  @override
  List<Object?> get props => [];
}

class DeleteColor extends DeleteColorEvent {
  int id;
  VoidCallback onSuccess;
  Function(String) onFail;

  DeleteColor(
      {required this.id, required this.onFail, required this.onSuccess});

  @override
  List<Object?> get props => [id, onFail, onSuccess];
}
