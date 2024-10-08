import 'dart:convert';

import 'package:hacker_kernel_test/core/failure/server_exception.dart';
import 'package:hacker_kernel_test/core/localStorage/init_shared_pref.dart';
import 'package:hacker_kernel_test/features/home/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProducts {
  Future saveProducts(ProductModel product) async {
    List<String> productsList =
        await SharedPref.preferences.getStringList("product") ?? [];
    productsList.add(jsonEncode(product));
    await SharedPref.preferences.setStringList("product", productsList);
    print(productsList);
  }

  Future<List<ProductModel>?>? getProducts() async {
    List<ProductModel> products = [];
    List<String>? productsList =
        await SharedPref.preferences.getStringList("product") ?? [];
    if (productsList != []) {
      for (var item in productsList!) {
        products.add(ProductModel.fromJson(jsonDecode(item)));
      }
    }
    return products;
  }

  removeProduct(productId) async {
    try {
      List<String> productsList = [];
      List<ProductModel>? products = await getProducts();
      products!.removeWhere((element) => element.id == productId);
      for (var item in products) {
        productsList.add(jsonEncode(item));
      }
      print(productsList);
      await SharedPref.preferences.setStringList("product", productsList);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
