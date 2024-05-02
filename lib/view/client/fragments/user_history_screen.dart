import 'package:e_kantin/widget/appbar/appbar.dart';
import 'package:e_kantin/widget/historyScreen/history_list_item.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHistoryScreen extends StatelessWidget {
  const UserHistoryScreen({super.key, this.arrow = false});

  final bool arrow;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: arrow,
        iconColor: Colors.black,
        title: Text(
          'History',
          style: GoogleFonts.poppins(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        child: const HistoryListItem(),
      ),
    );
  }
}
