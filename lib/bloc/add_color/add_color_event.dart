import 'package:equatable/equatable.dart';
import 'package:inventory_hp/data/model/phone_color.dart';

abstract class AddColorEvent extends Equatable {
  AddColorEvent();

  @override
  List<Object?> get props => [];
}

class AddColor extends AddColorEvent {
  String color;
  Function(PhoneColor) onSuccess;
  Function(String) onFail;

  AddColor(
      {required this.color, required this.onSuccess, required this.onFail});

  @override
  List<Object?> get props => [color, onSuccess, onFail];
}
