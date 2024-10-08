import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacker_kernel_test/core/localStorage/product.dart';
import 'package:hacker_kernel_test/core/localStorage/token.dart';
import 'package:hacker_kernel_test/features/auth/view/pages/login_screen.dart';
import 'package:hacker_kernel_test/features/auth/view/widgets/repeated_text_field.dart';
import 'package:hacker_kernel_test/features/home/model/product_model.dart';
import 'package:hacker_kernel_test/features/home/view/pages/add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  List<ProductModel> productsList = [];
  List<ProductModel> filteredProductsList = [];
  bool isLoading = false;

  getProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      productsList = await SharedPrefProducts().getProducts() ?? [];
      filteredProductsList = productsList;
    } catch (e) {
      print('----------> $e');
    } finally {
      Future.delayed(Duration(seconds: 1)).whenComplete(() => setState(() {
            isLoading = false;
          }));
    }
  }

  searchProducts(String query) {
    if (query.isEmpty) {
      filteredProductsList = productsList;
    } else {
      filteredProductsList = productsList
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  Future.delayed(Duration(seconds: 1)).whenComplete(() {
                    SharedPrefToken().removeToken();
                    Get.to(() => LoginScreen());
                  });
                },
                child: Text('Yes')),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('No'))
          ],
        );
      },
    );
  }

  final searchController = TextEditingController();
  bool showSearchField = false;

  @override
  Widget build(BuildContext context) {
    print('---------->');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(Icons.navigate_before, size: 40, color: Colors.grey),
              ),
            ),
            Spacer(),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    showSearchField = !showSearchField;
                  });
                  searchProducts('');
                },
                icon: Icon(
                  showSearchField ? Icons.cancel : Icons.search,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: showSearchField
                              ? SizedBox(
                                  width: Get.width,
                                  child: RepeatedTextField(
                                    controller: searchController,
                                    hint: 'Search',
                                    onChanged: (value) {
                                      searchProducts(value);
                                    },
                                  ))
                              : SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi-Fi Shop & Service",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 28),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Audio on Rustavelie Ave 57. \nThis shop offers both products and services",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        if (filteredProductsList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Text(
                                  "Products ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "${filteredProductsList.length}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              ...List.generate(filteredProductsList.length,
                                  (index) {
                                ProductModel product =
                                    filteredProductsList[index];
                                return Container(
                                  width: Get.width * 0.42,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              height: 140,
                                              width: 170,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Image.file(
                                                  File(product.image),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          Positioned(
                                              right: 10,
                                              top: 0,
                                              child: Card(
                                                child: IconButton(
                                                    onPressed: () async {
                                                      await SharedPrefProducts()
                                                          .removeProduct(
                                                              product.id);
                                                      getProducts();
                                                      setState(() {});
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.black,
                                                    )),
                                              ))
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '\$' + "${product.price}.00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (filteredProductsList.isEmpty)
                  Center(
                    child:
                        Text('No products found! \nPlease add some products'),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(160)),
        onPressed: () {
          Get.to(() => AddProductScreen())!.then((value) => setState(() {
                getProducts();
              }));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }
}
