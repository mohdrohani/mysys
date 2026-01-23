class Warehouse {
  final int id;
  final String name;
  final String? location;

  Warehouse({
    required this.id,
    required this.name,
    this.location,
  });

  // Convert Map to Warehouse object
  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      id: map['id'] as int,
      name: map['name'] as String,
      location: map['location'] as String?,
    );
  }

  // Convert Warehouse to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}