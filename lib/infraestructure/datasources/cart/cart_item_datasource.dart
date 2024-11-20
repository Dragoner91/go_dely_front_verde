import 'package:go_dely/infraestructure/entities/cart/cart_items.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class CartItemDatasource {

  late Future<Isar> db;

  CartItemDatasource(){
    db = openDB();
  }

  Future<Isar> openDB() async {
    if( Isar.instanceNames.isEmpty){
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [CartItemSchema], 
        directory: dir.path, 
        inspector: true
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<bool> itemExistsInCart(String id) async {
    final isar = await db;
    return await isar.cartItems.where().filter().idEqualTo(id).count() > 0;
  }

  Future<void> addItemToCart(CartItem cartItem) async {
    final isar = await db;
    isar.writeTxn(() async {
      isar.cartItems.put(cartItem);
    });
  }

  Future<void> removeItemFromCart(int id) async {
    final isar = await db;
    isar.writeTxn(() async {
      isar.cartItems.delete(id);
    });
  }

  Future<List<CartItem>> getProductsFromCart() async {
    final isar = await db;
    return isar.txn(() async => (  await isar.cartItems.where().findAll() ),);
  }

  Future<void> incrementItem(String id) async {
  final isar = await db;
  await isar.writeTxn(() async {
    final item = await isar.cartItems.where().filter().idEqualTo(id).findFirst();
    if (item == null) {
      throw Exception('Item not found');
    }
    item.quantity++;
    await isar.cartItems.put(item);
    return item;
  });
}

  Future<void> decrementItem(String id) async {
  final isar = await db;
  await isar.writeTxn(() async {
    final item = await isar.cartItems.where().filter().idEqualTo(id).findFirst();
    if (item == null) {
      throw Exception('Item not found');
    }
    if(item.quantity == 1){
      return item;
    }
    item.quantity--;
    await isar.cartItems.put(item);
    return item;
  });
}

  Future<Stream<List<CartItem>>> watchAllItemsFromCart() async {
    final isar = await db;
    return isar.cartItems.where().watch(fireImmediately: true);
  }
}