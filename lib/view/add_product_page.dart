import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tigercashiraq/controler/store_getx.dart';
import 'dart:io';

import 'package:tigercashiraq/model/product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final StoreController controller = Get.find();
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        controller.addPhotoFromGallery(pickedFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المنتج'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المنتج';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'تفاصيل المنتج'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال تفاصيل المنتج';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantityController,
                decoration:
                    const InputDecoration(labelText: 'عدد القطع المتوفرة'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال عدد القطع المتوفرة';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'سعر المنتج'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال سعر المنتج';
                  }
                  return null;
                },
              ),
              Obx(() => DropdownButtonFormField<int>(
                    value: controller.selectedCategory.value,
                    items: controller.categories
                        .asMap()
                        .entries
                        .map((entry) => DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedCategory.value = value!;
                      controller.srtselcetedTipy(value);
                    },
                    decoration: const InputDecoration(labelText: 'نوع المنتج'),
                  )),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        color: Colors.grey[300],
                        height: 150,
                        width: double.infinity,
                        child: const Icon(Icons.add_a_photo,
                            color: Colors.grey, size: 50),
                      )
                    : Image.file(
                        _image!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newProduct = Product(
                      name: nameController.text,
                      price: priceController.text,
                      // image: _image?.path ?? '',
                      description: detailsController.text,
                      type: controller.selectedTipy.value,
                      quntity:
                          quantityController.text, // Use the image path here
                    );

                    controller.addProduct(newProduct, _image);
                    Get.back();
                  }
                },
                child: const Text('إضافة المنتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
