import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_dely/infraestructure/datasources/product_db_datasource.dart';
import 'package:go_dely/infraestructure/repositories/product_repository_impl.dart';

final productRepositoryProvider = Provider((ref) {
    return ProductRepositoryImpl(datasource: ProductDBDatasource());
  },
);