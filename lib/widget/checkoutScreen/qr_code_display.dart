import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class QRCodeDisplay extends StatelessWidget {
  final String qrCodePath;

  const QRCodeDisplay({
    super.key,
    required this.qrCodePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Center(
          child: qrCodePath.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: qrCodePath,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                )
              : const Text('Seller dont have QRIS yet :('),
        ),
      ),
    );
  }
}
