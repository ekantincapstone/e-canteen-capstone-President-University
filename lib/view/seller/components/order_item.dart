import 'package:e_kantin/models/orders.dart' as mo;
import 'package:e_kantin/models/users.dart' as mu;
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/seller/fragments/order_detail.dart';
import 'package:e_kantin/view/seller/fragments/receive_order.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatefulWidget {
  final mo.Order order;
  const OrderItem({
    super.key,
    required this.order,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  late Future<mu.User> userFuture;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      userFuture = fetchUser();
      isLoaded = true;
    }
  }

  Future<mu.User> fetchUser() async {
    final uvm = Provider.of<UsersViewModel>(context, listen: true);
    await uvm.fetchUsers();
    return uvm.getUserById(widget.order.userId)!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<mu.User>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          mu.User user = snapshot.data!;
          return body(
            user: user,
            widget: widget,
          );
        } else {
          return const Center(
            child: Text(
              'No accounts available. Please add your Bank Accounts in profile page.',
            ),
          );
        }
      },
    );
  }
}

class body extends StatelessWidget {
  final mu.User user;
  const body({
    super.key,
    required this.widget,
    required this.user,
  });

  final OrderItem widget;

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
    final List funcOnTap = [
      () {
        Get.to(
          () => ReceiveOrder(
            order: widget.order,
            orderNumber: widget.order.id,
            status: status[widget.order.status],
            orderDate: widget.order.createdAt.toDate(),
            products: widget.order.products,
            totalCost: widget.order.amount,
            color: statusColor[widget.order.status],
          ),
        );
      },
      () {
        Get.to(
          () => OrderDetail(
            order: widget.order,
            orderNumber: widget.order.id,
            status: status[widget.order.status],
            orderDate: widget.order.createdAt.toDate(),
            products: widget.order.products,
            totalCost: widget.order.amount,
            color: statusColor[widget.order.status],
            isCompleted: false,
          ),
        );
      },
      () {
        Get.to(
          () => OrderDetail(
            order: widget.order,
            orderNumber: widget.order.id,
            status: status[widget.order.status],
            orderDate: widget.order.createdAt.toDate(),
            products: widget.order.products,
            totalCost: widget.order.amount,
            color: statusColor[widget.order.status],
            isCompleted: true,
          ),
        );
      },
      () {},
    ];

    return Padding(
      padding: EdgeInsets.only(
        bottom: getProportionateScreenHeight(16),
      ),
      child: GestureDetector(
        onTap: funcOnTap[widget.order.status],
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.14,
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenHeight(18),
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.order.products.length} Item(s)",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(12),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: getProportionateScreenWidth(80),
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(4),
                    ),
                    decoration: BoxDecoration(
                        color: statusColor[widget.order.status],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text(
                        status[widget.order.status],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenHeight(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(widget.order.amount),
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Text(
                    DateFormat('HH.mm  -  dd MMM yyy').format(
                      widget.order.createdAt.toDate(),
                    ),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
