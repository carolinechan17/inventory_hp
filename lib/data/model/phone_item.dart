class PhoneItem {
  int? id;
  int? colorId;
  String? color;
  String? name;
  String? imei;

  PhoneItem({this.id, this.color, this.colorId, this.imei, this.name});

  factory PhoneItem.fromJson(Map<String, dynamic> json) => PhoneItem(
        id: json['id'],
        color: json['color'],
        colorId: json['color_id'],
        name: json['name'],
        imei: json['imei'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
        'color_id': colorId,
        'name': name,
        'imei': imei,
      };
}
