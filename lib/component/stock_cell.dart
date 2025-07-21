import 'package:flutter/material.dart';
import 'package:inventory_hp/data/model/phone_item.dart';

class StockCell extends StatelessWidget {
  StockCell({super.key, required this.item});

  PhoneItem item;

  @override
  Widget build(BuildContext context) {
    List<String> imei = item.imei!.split(',');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${imei.length} items',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          Text(
            'Color: ${item.color}',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          if (imei.isNotEmpty)
            ...imei.map((item) => Text(
                  '• ${item.trim()}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
        ],
      ),
    );
  }
}
