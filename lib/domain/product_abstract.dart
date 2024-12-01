abstract class ProductAbstract {
  
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String currency; 
  final double discount; 




  ProductAbstract({
    required this.id, 
    required this.name, 
    required this.price, 
    required this.description, 
    required this.category, 
    required this.currency,
    required this.discount
    });
  
}