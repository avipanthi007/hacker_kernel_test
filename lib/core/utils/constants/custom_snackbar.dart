  import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController customSnackbar(String message) => Get.snackbar('Message', message, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM);
