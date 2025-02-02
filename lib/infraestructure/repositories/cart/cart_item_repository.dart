import 'package:go_dely/domain/cart/i_cart.dart';
import 'package:go_dely/domain/cart/i_cart_repository.dart';
import 'package:go_dely/domain/discount/discount.dart';
import 'package:go_dely/domain/discount/i_discount_repository.dart';
import 'package:go_dely/domain/users/i_auth_repository.dart';
import 'package:go_dely/infraestructure/entities/cart/cart_items.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class CartItemRepository extends ICartRepository{
  final IAuthRepository auth;
  final IDiscountRepository discountRepo;
  late Future<Isar> db;

  CartItemRepository({required this.auth, required this.discountRepo}){
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

  @override
  Future<bool> itemExistsInCart(String id) async {
    final isar = await db;
    return await isar.cartItems.where().filter().idEqualTo(id).count() > 0;
  }

  @override
  Future<void> addItemToCart(ICart cartItem) async {
    final isar = await db;
    isar.writeTxn(() async {
      isar.cartItems.put(cartItem as CartItem);
    });
  }

  @override
  Future<void> removeItemFromCart(int id) async {
    final isar = await db;
    isar.writeTxn(() async {
      isar.cartItems.delete(id);
    });
  }

  @override
  Future<List<ICart>> getItemsFromCart() async {
    final isar = await db;
    return isar.txn(() async => (  await isar.cartItems.where().findAll() ),);
  }

  @override
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
  
  @override
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

  @override
  Future<Stream<List<ICart>>> watchAllItemsFromCart() async {
    final isar = await db;
    return isar.cartItems.where().watch(fireImmediately: true);
  }

  @override
  Future<void> cleanItems() async {
    final items = await getItemsFromCart();
    for (var item in items) {
      var cartItem = item as CartItem;
      await removeItemFromCart(cartItem.isarId!.toInt());
    }
  }

  @override
  Future<double> calculateTotal() async {
    final items = await getItemsFromCart();
    double total = 0;
    double discount = 0;
    for (var item in items) {
      discount = 0;
      if (item.discount != "No Discount"){
        final discountResult = await discountRepo.getDiscountById(GetDiscountByIdDto(item.discount));
        discount = discountResult.unwrap().percentage;
      }
      total += item.price * item.quantity * (1 - discount);
    }
    return total;
  }

}