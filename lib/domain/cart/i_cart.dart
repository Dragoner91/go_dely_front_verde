
//*agregar tipo item si es producto o combo

class ICart {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String currency;
  final String image; 
  int quantity;

  ICart({
    required this.quantity, 
    required this.category, 
    required this.currency, 
    required this.description, 
    required this.id, 
    required this.image, 
    required this.name, 
    required this.price
  });

}