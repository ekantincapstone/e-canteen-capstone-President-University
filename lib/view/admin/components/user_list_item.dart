import 'package:e_kantin/constant.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/models/users.dart' as mu;
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/admin/user_detail.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatefulWidget {
  final mu.User user;
  const UserItem({super.key, required this.user});

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
  }

  void initAsync() async {
    final viewModel = Provider.of<SellerViewModel>(context, listen: false);
    await viewModel.fetchSellers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerViewModel>(
      builder: (context, sellerViewModel, child) {
        final Seller? seller =
            sellerViewModel.getSellerByUserId(widget.user.userId);
        return seller != null || widget.user.role == 0
            ? Padding(
                padding:
                    EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserDetail(
                        user: widget.user,
                      ),
                    ),
                  ),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight * 0.1,
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(20),
                      vertical: getProportionateScreenHeight(15),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(color: Colors.black12),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.user.role == 0
                                    ? widget.user.name
                                    : "${widget.user.name} (${seller?.storeName})",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    10), // Add some space between the two Text widgets
                            Text(
                              widget.user.role == 0 ? "Student" : "Seller",
                              style: const TextStyle(
                                  color: kMainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          widget.user.email,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
