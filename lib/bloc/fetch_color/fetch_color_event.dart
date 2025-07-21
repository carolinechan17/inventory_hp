import 'package:equatable/equatable.dart';
import 'package:inventory_hp/data/model/phone_color.dart';

abstract class FetchColorEvent extends Equatable {
  FetchColorEvent();

  @override
  List<Object?> get props => [];
}

class GetColors extends FetchColorEvent {
  @override
  List<Object?> get props => [];
}

class HandleAddColor extends FetchColorEvent {
  PhoneColor data;

  HandleAddColor({required this.data});

  @override
  List<Object?> get props => [data];
}
