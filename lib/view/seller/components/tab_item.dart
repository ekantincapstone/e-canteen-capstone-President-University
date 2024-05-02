import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int count;
  const TabItem({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          // count > 0
          //     ? Container(
          //         margin: EdgeInsetsDirectional.only(
          //           start: getProportionateScreenWidth(5),
          //         ),
          //         padding: EdgeInsets.all(
          //           getProportionateScreenWidth(3),
          //         ),
          //         decoration: BoxDecoration(
          //           color: Colors.grey.shade200,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Text(
          //           count > 9 ? "9+" : count.toString(),
          //           style: TextStyle(
          //             color: Colors.black54,
          //             fontSize: getProportionateScreenWidth(10),
          //           ),
          //         ),
          //       )
          //     : const SizedBox()
        ],
      ),
    );
  }
}
