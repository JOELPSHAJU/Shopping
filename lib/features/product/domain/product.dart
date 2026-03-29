class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String category;
  final String brand;
  final String? imageAsset;
  final bool isArchived;
  final String? collectionId;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.brand,
    this.imageAsset,
    this.isArchived = false,
    this.collectionId,
  });
}
