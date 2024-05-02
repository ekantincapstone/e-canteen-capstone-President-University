import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_kantin/models/orders.dart' as mo;
import 'package:e_kantin/models/products.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryDetail extends StatefulWidget {
  final mo.Order order;
  final String orderNumber;
  final String status;
  final DateTime orderDate;
  final List<dynamic> products;
  final int totalCost;
  final Color color;

  const HistoryDetail({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.orderDate,
    required this.products,
    required this.totalCost,
    required this.order,
    required this.color,
  });

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final pvm = Provider.of<ProductViewModel>(context, listen: false);
        pvm.fetchProductsBySellerId(widget.order.sellerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, pvm, child) {
          if (pvm.isLoading || pvm.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return OrderDetailBody(
            orderNumber: widget.orderNumber,
            status: widget.status,
            orderDate: widget.orderDate,
            products: widget.products,
            totalCost: widget.totalCost,
            productsSeller: pvm.products,
            order: widget.order,
            color: widget.color,
          );
        },
      ),
    );
  }
}

class OrderDetailBody extends StatelessWidget {
  final mo.Order order;
  final String orderNumber;
  final String status;
  final DateTime orderDate;
  final List<dynamic> products;
  final int totalCost;
  final List<Product> productsSeller;
  final Color color;

  const OrderDetailBody({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.orderDate,
    required this.products,
    required this.totalCost,
    required this.productsSeller,
    required this.order,
    required this.color,
  });

  String? getProductNameById(String productId, List<Product> productsList) {
    final Product product = productsList.firstWhere((p) => p.id == productId);
    return product.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order: #${orderNumber.substring(0, 6)}',
            style: GoogleFonts.poppins(
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: $status',
                style: GoogleFonts.poppins(
                  fontSize: getProportionateScreenWidth(16),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Date: ${DateFormat('HH:mm  -  dd MMM yyyy').format(orderDate)}',
                style: GoogleFonts.poppins(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(16)),
          Divider(thickness: 2, color: Colors.grey.shade300),
          SizedBox(height: getProportionateScreenHeight(16)),
          Text(
            'Products ordered:',
            style: GoogleFonts.poppins(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var productName = getProductNameById(products[index]['product'], productsSeller);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(4),
                  ),
                  child: Text(
                    '- ${products[index]['quantity']}x ${productName ?? 'Product not found'}',
                    style: GoogleFonts.poppins(
                      fontSize: getProportionateScreenWidth(16),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: RoundedButton(
              text: "Proof Payment",
              press: () => showDialog(
                context: context,
                builder: (context) => CachedNetworkImage(imageUrl: order.proofPayment),
              ),
              width: SizeConfig.screenWidth * 0.8,
              border: 10,
              hPadding: 15,
              vPadding: 10,
              margin: 0,
            ),
          ),
          Divider(thickness: 2, color: Colors.grey.shade300),
          SizedBox(height: getProportionateScreenHeight(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(18),
                ),
              ),
              Text(
                formatCurrency(totalCost),
                style: GoogleFonts.poppins(
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
