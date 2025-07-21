import 'package:inventory_hp/data/model/phone_color.dart';
import 'package:inventory_hp/data/model/phone_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> uploadPhoneItems(List<Map<String, dynamic>> phones) async {
  try {
    final supabase = Supabase.instance.client;

    for (final item in phones) {
      if (item['id'] == 0) {
        final insertItem = Map<String, dynamic>.from(item);
        insertItem.remove('id');
        await supabase.from('phones').insert(insertItem).select();
      } else {
        await supabase.from('phones').update({
          'id': item['id'],
          'name': item['name'],
          'color_id': item['color_id'],
          'color': item['color'],
          'imei': item['imei'],
        }).eq('id', item['id']);
      }
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<void> deletePhoneItem(int id) async {
  try {
    final supabase = Supabase.instance.client;

    await supabase.from('phones').delete().eq('id', id);
  } catch (e) {
    throw Exception(e);
  }
}

Future<void> updateOnePhoneItem(Map<String, dynamic> phone) async {
  try {
    final supabase = Supabase.instance.client;

    await supabase.from('phones').update({
      'id': phone['id'],
      'name': phone['name'],
      'color_id': phone['color_id'],
      'color': phone['color'],
      'imei': phone['imei'],
    }).eq('id', phone['id']);
  } catch (e) {
    throw Exception(e);
  }
}

Future<void> updatePhoneItems(List<Map<String, dynamic>> phones) async {
  try {
    final supabase = Supabase.instance.client;

    for (final item in phones) {
      final int id = item['id'];
      final List<Map<String, bool>> imeiList =
          List<Map<String, bool>>.from(item['imei']);

      final List<String> falseImeis = imeiList
          .where((map) => map.values.first == false)
          .map((map) => map.keys.first)
          .toList();

      if (falseImeis.isEmpty) {
        await supabase.from('phones').delete().eq('id', id);
      } else {
        final String imeiString = falseImeis.join(',');

        await supabase.from('phones').update({
          'imei': imeiString,
        }).eq('id', id);
      }
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<PhoneItem>> fetchAllPhoneItems() async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('phones').select('*');

    return response.map((json) {
      final phone = PhoneItem.fromJson(json);
      return phone;
    }).toList();
  } catch (e) {
    throw Exception(e);
  }
}

Future<PhoneColor> addPhoneColor(String color) async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('phone_colors').insert([
      {'color': color}
    ]).select();

    return PhoneColor.fromJson(response.first);
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<PhoneColor>> fetchAllPhoneColors() async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('phone_colors').select('*');

    return response.map((json) {
      final phone = PhoneColor.fromJson(json);
      return phone;
    }).toList();
  } catch (e) {
    throw Exception(e);
  }
}
