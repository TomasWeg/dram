import 'dart:convert';

class Order {
  final String fieldName;
  final OrderDirection direction;

  const Order(this.fieldName, {this.direction = OrderDirection.Ascending});

  factory Order.ascending(String fieldName) => Order(fieldName);
  factory Order.descending(String fieldName) => Order(fieldName, direction: OrderDirection.Descending);

  Map<String, dynamic> toJson() {
    return {
      "fieldName": this.fieldName,
      "direction": this.direction.index
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

enum OrderDirection {
  Ascending,
  Descending
}