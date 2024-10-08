import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hacker_kernel_test/core/localStorage/product.dart';
import 'package:hacker_kernel_test/features/auth/view/widgets/custom_button.dart';
import 'package:hacker_kernel_test/features/auth/view/widgets/repeated_text_field.dart';
import 'package:hacker_kernel_test/features/home/model/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceController = TextEditingController();
  final _nameController = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Add Product",
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                      height: 150,
                      width: 150,
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(160),
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              ))
                          : CircleAvatar()),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () async {
                            image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {});
                          },
                          icon: Icon(Icons.photo)))
                ],
              ),
              RepeatedTextField(
                  validator: (val) => val!.trim().length == 0
                      ? "Please enter product name"
                      : null,
                  controller: _nameController,
                  hint: "Product Name"),
              SizedBox(height: 20),
              RepeatedTextField(
                validator: (val) =>
                    val!.trim().length == 0 ? "Please enter price" : null,
                controller: _priceController,
                hint: "Price",
                isNum: true,
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  if (image == null) {
                    Get.snackbar("Message", "Please pick a product image",
                        backgroundColor: Colors.white);
                    return;
                  }
                  if (_globalKey.currentState!.validate()) {
                    List<ProductModel> productsList =
                        await SharedPrefProducts().getProducts() ?? [];

                    var uuid = Uuid();
                    ProductModel product = ProductModel(
                        id: uuid.v4(),
                        name: _nameController.text,
                        image: image!.path,
                        price: _priceController.text);

                    bool productExists =
                        productsList.any((p) => p.name == product.name);

                    if (productExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Cannot add product with the same name!',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          showCloseIcon: true,
                          closeIconColor: Colors.black,
                          onVisible: () {
                            Vibration.vibrate();
                          },
                        ),
                      );
                    } else {
                      SharedPrefProducts()
                          .saveProducts(product)
                          .then((value) => Get.back());
                    }
                  }
                },
                child: CustomButton(
                  item: Text(
                    "ADD",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  color: Colors.blue.shade600,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
