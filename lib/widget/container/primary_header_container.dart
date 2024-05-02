import 'package:e_kantin/constant.dart';
import 'package:e_kantin/widget/container/circular_container.dart';
import 'package:e_kantin/widget/custom_shapes/curved_edge_widget.dart';
import 'package:flutter/material.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgeWidget(
      child: Container(
        color: kMainColor,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: CircularContainer(
                backgroundColor: kSecondaryColor.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: CircularContainer(
                backgroundColor: kSecondaryColor.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
