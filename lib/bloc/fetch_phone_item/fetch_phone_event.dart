import 'package:equatable/equatable.dart';
import 'package:inventory_hp/data/model/phone_item.dart';

abstract class FetchPhoneEvent extends Equatable {
  FetchPhoneEvent();

  @override
  List<Object?> get props => [];
}

class GetPhones extends FetchPhoneEvent {
  @override
  List<Object?> get props => [];
}

class HandleAddPhones extends FetchPhoneEvent {
  List<PhoneItem> data;

  HandleAddPhones({required this.data});

  @override
  List<Object?> get props => [data];
}

class SearchPhones extends FetchPhoneEvent {
  String query;

  SearchPhones({required this.query});

  @override
  List<Object?> get props => [query];
}
