class Product {
  final int? id;
  final String name;
  final String? barcode;
  final double price;
  final String? description;
  final String? imageUrl;

  Product({
    this.id,
    required this.name,
    this.barcode,
    required this.price,
    this.description,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      // API'den gelen sayı int olabilir ama biz double kullanıyoruz, toDouble() ile güvene alalım.
      price: (json['price'] as num).toDouble(), 
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'price': price,
      'description': description,
    };
  }
}
