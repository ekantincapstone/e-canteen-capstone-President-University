import 'package:e_kantin/models/orders.dart' as mo;
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/viewmodel/order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/widget/container/rounded_container.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/view/client/fragments/user_history_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryListItem extends StatefulWidget {
  const HistoryListItem({super.key});

  @override
  State<HistoryListItem> createState() => _HistoryListItemState();
}

class _HistoryListItemState extends State<HistoryListItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
  }

  void initAsync() async {
    final prefs = SharedPreferencesService.instance;
    await Provider.of<OrderViewModel>(context, listen: false)
        .fetchOrdersForUser(prefs.getUserID() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, ovm, child) {
        return ovm.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ovm.userOrders.isEmpty
                ? const Center(
                    child: Text('No Order'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: ovm.userOrders.length,
                    separatorBuilder: (_, __) => Divider(
                      color: kMainColor.withOpacity(0.2),
                      height: getProportionateScreenHeight(16),
                    ),
                    itemBuilder: (_, index) =>
                        UserHistoryItem(order: ovm.userOrders[index]),
                  );
      },
    );
  }
}

class UserHistoryItem extends StatelessWidget {
  final mo.Order order;
  const UserHistoryItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> status = [
      "Pending",
      "Processing",
      "Completed",
      "Canceled",
    ];
    final List<Color> statusColor = [
      Colors.blue.shade700,
      Colors.orange.shade700,
      Colors.green.shade700,
      Colors.red.shade700,
    ];
    return RoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.ship, color: statusColor[order.status]),
              const SizedBox(width: 8),
              Text(
                status[order.status],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: statusColor[order.status],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.to(() => HistoryDetail(
                        orderNumber: order.id,
                        orderDate: order.createdAt.toDate(),
                        products: order.products,
                        // .map((product) => product["product"].toString())
                        // .toList(),
                        status: status[order.status],
                        totalCost: order.amount,
                        order: order,
                        color: statusColor[order.status],
                      ));
                },
                icon: const Icon(
                  Iconsax.arrow_right_34,
                  size: 24,
                  color: kMainColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Iconsax.tag, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Order #[${order.id.substring(0, 6)}]',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenHeight(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Iconsax.calendar, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Order Date: ${DateFormat('HH:mm  -  dd MMM yyyy').format(order.createdAt.toDate())}',
                style: GoogleFonts.poppins(
                  // Menggunakan GoogleFonts.poppins
                  fontSize: getProportionateScreenHeight(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
