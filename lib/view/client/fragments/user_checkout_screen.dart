import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:e_kantin/models/cart_product.dart';
import 'package:e_kantin/models/orders.dart' as mo;
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/client/fragments/user_succes_checkout.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:e_kantin/viewmodel/order_viewmodel.dart';
import 'package:e_kantin/widget/appbar/appbar.dart';
import 'package:e_kantin/widget/checkoutScreen/confirm_payment_button.dart';
import 'package:e_kantin/widget/checkoutScreen/image_upload_widget.dart';
import 'package:e_kantin/widget/checkoutScreen/qr_code_display.dart';
import 'package:e_kantin/widget/checkoutScreen/total_payment_display.dart';
import 'package:e_kantin/widget/custom_shapes/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final int total;
  final List<CartProduct> cart;

  const CheckoutScreen({
    super.key,
    required this.total,
    required this.cart,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  File? _uploadedImage;
  String? _qrCodePath;

  @override
  void initState() {
    super.initState();
    _loadSellerQRCode();
  }

  Future<void> _pickImage() async {
    final loadingDialog = LoadingDialog(context);

    try {
      loadingDialog.show("Uploading payment proof...");

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _uploadedImage = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No image selected. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    } finally {
      loadingDialog.hide(); // Always hide the loading dialog, even on error
    }
  }

  Future<void> _loadSellerQRCode() async {
    String qrCodePath = Provider.of<SellerViewModel>(context, listen: false)
        .getSellerById(widget.cart[0].product.sellerId)!
        .qrUrl;

    if (mounted) {
      setState(() {
        _qrCodePath = qrCodePath;
      });
    }
  }

  String generateRandomString(int length) {
    const String _chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<void> _uploadProof(String orderId) async {
    final loadingDialog = LoadingDialog(context);

    loadingDialog.show("Uploading payment proof...");
    if (_uploadedImage != null) {
      loadingDialog.hide();
      File file = _uploadedImage!;
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('payments/pay_$orderId.png')
            .putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        _updatePicUrl(downloadUrl, orderId);
      } catch (e) {
        loadingDialog.hide();
        print('Failed to upload QR: $e');
      }
    }
  }

  void _updatePicUrl(String newUrl, String orderId) {
    FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'payment_proof': newUrl,
    });
  }

  Future<String?> getSellerToken(String sellerId) async {
    try {
      var document = await FirebaseFirestore.instance
          .collection('tokens')
          .doc(sellerId)
          .get();
      if (document.exists && document.data()!.containsKey('token')) {
        return document.data()!['token'] as String?;
      }
      return null;
    } catch (e) {
      print("Error fetching user token: $e");
      return null;
    }
  }

  Future<void> sendNotification(String token, String title, String body) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendNotification');
      final result = await callable.call({
        'token': token,
        'title': title,
        'body': body,
      });
      print('Notification sent, response: ${result.data}');
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Checkout'),
        showBackArrow: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_qrCodePath != null)
                QRCodeDisplay(qrCodePath: _qrCodePath ?? ''),
              const Divider(height: 40),
              TotalPaymentDisplay(total: widget.total),
              const Divider(height: 40),
              ImageUploadWidget(
                onPickImage: _pickImage,
                uploadedImage: _uploadedImage,
              ),
              const Divider(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundedButton(
                    text: 'Cancel',
                    press: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cancelled!')),
                      );
                      Navigator.pop(context);
                    },
                    width: SizeConfig.screenWidth * 0.3,
                    hPadding: 10,
                    vPadding: 16,
                    border: 10,
                    color: Colors.red.shade700,
                  ),
                  ConfirmPaymentButton(
                    isProofUploaded: _uploadedImage != null,
                    onConfirm: () {
                      final loadingDialog = LoadingDialog(context);

                      loadingDialog.show("Confirming payment...");
                      final String? userId =
                          SharedPreferencesService.instance.getUserID();
                      if (_uploadedImage != null && userId != null) {
                        Provider.of<OrderViewModel>(context, listen: false)
                            .addOrder(
                              mo.Order.fromMap({
                                "buyer_id": userId,
                                "seller_id": widget.cart[0].product.sellerId,
                                "products":
                                    widget.cart.map((e) => e.toJson()).toList(),
                                "amount": widget.total,
                                "created_at": Timestamp.now(),
                                "status": 0,
                                "proof_payment": ''
                              }, ''),
                            )
                            .then((value) => _uploadProof(value))
                            .then((value) async {
                              loadingDialog.hide();

                              String token = await getSellerToken(
                                      widget.cart[0].product.sellerId) ??
                                  '';
                              sendNotification(token, "New Order!",
                                  "You receive a new order!");
                            })
                            .then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Payment confirmed!')),
                                ))
                            .then((value) =>
                                Get.to(() => const CheckoutSuccess()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please upload payment proof')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
