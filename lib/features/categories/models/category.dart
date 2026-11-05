/// Category model — mock data placeholder.
class Category {
  final String id;
  final String name;
  final String imageUrl;
  final String? parentId;
  final List<Category> subcategories;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.parentId,
    this.subcategories = const [],
    this.productCount = 0,
  });

  factory Category.mock({required String id, required String name}) {
    return Category(
      id: id,
      name: name,
      imageUrl: 'https://via.placeholder.com/300x300.png?text=$name',
      productCount: 24,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && id == other.id;

  @override
  int get hashCode => id.hashCode;
}