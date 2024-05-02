import 'dart:io';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';
import 'package:e_kantin/widget/custom_shapes/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final Seller seller;
  const AddProduct({super.key, required this.seller});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late int _productPrice;
  late String _productDescription;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ProductViewModel pvm = ProductViewModel();

Future<void> pickImage() async {
  final loadingDialog = LoadingDialog(context);

  try {
    loadingDialog.show("Loading image...");

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected. Please try again.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error picking image: $e')),
    );
  } finally {
    loadingDialog.hide(); // Always hide the loading dialog, even on error
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight * 0.01,
          horizontal: SizeConfig.screenWidth * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextFormField(
                label: 'Product Name',
                saveValue: (value) => _productName = value,
              ),
              buildSizedBox(),
              buildTextFormField(
                label: 'Product Price',
                keyboardType: TextInputType.number,
                saveValue: (value) => _productPrice = int.parse(value),
              ),
              buildSizedBox(),
              buildTextFormField(
                label: 'Description',
                saveValue: (value) => _productDescription = value,
              ),
              const SizedBox(height: 20),
              buildImagePicker(),
              RoundedButton(
                text: 'Add Product',
                press: uploadProduct,
                width: double.infinity,
                border: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String label,
    TextInputType? keyboardType,
    required Function(String) saveValue,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
      onSaved: (value) => saveValue(value!),
    );
  }

  SizedBox buildSizedBox() => const SizedBox(height: 20);

  Widget buildImagePicker() {
    return _image == null
        ? ElevatedButton(
            onPressed: pickImage,
            child: const Text('Pick Image'),
          )
        : Image.file(_image!);
  }

  Future<void> uploadProduct() async {
    final loadingDialog = LoadingDialog(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_image != null) {
        loadingDialog.show("Uploading product");
        try {
          String downloadURL = await pvm.uploadImage(_image);
          String sellerId = widget.seller.id;

          // Save the product info
          await pvm.saveProductInfo(downloadURL, _productName, _productPrice,
              _productDescription, sellerId);

          // Hiding the loading dialog and navigating back
          loadingDialog.hide();
          Navigator.pop(context);
        } catch (e) {
          loadingDialog.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading product: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image to upload')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out the form properly')),
      );
    }
  }
}
