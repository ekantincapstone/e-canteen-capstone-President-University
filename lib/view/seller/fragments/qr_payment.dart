import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/widget/custom_shapes/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';

class SellerQRPage extends StatefulWidget {
  final Seller seller;
  const SellerQRPage({super.key, required this.seller});

  @override
  State<SellerQRPage> createState() => _SellerQRPageState();
}

class _SellerQRPageState extends State<SellerQRPage> {
  final ImagePicker _picker = ImagePicker();

  void _updateQRUrl(String newUrl) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.seller.id)
        .update({
      'qr_url': newUrl,
    });
  }

  Future<void> _uploadNewQR() async {
    final loadingDialog = LoadingDialog(context);

    try {
      loadingDialog.show("Uploading QR Code...");

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        File file = File(image.path);

        // Mengupload file ke Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('uploads/${widget.seller.id}_qr.png')
            .putFile(file);

        // Mendapatkan URL dari QR Code yang diunggah
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update URL QR Code
        _updateQRUrl(downloadUrl);

        Provider.of<SellerViewModel>(context, listen: false)
            .updateSellerQR(widget.seller.id, downloadUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code uploaded successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No QR Code selected. Please try again.')),
        );
      }
    } catch (e) {
      print('Failed to upload QR: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading QR Code: $e')));
    } finally {
      loadingDialog.hide(); // Selalu tutup loading dialog, apa pun hasilnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR Code'),
      ),
      body: Consumer<SellerViewModel>(
        builder: (context, sellerViewModel, child) {
          sellerViewModel.getSellerByUserId(widget.seller.id);
          if (sellerViewModel.currentSeller != null) {
            Seller? seller = sellerViewModel.currentSeller;
            return Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: seller!.qrUrl.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(
                                getProportionateScreenHeight(20)),
                            child: CachedNetworkImage(
                              imageUrl: seller.qrUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )
                        : const Text('No QR Code uploaded. Please upload one.'),
                  ),
                ),
                RoundedButton(
                  text: 'Upload New QR Code',
                  press: _uploadNewQR,
                  width: SizeConfig.screenWidth * 0.9,
                  border: 10,
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
