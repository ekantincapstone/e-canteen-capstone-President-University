import 'package:e_kantin/models/users.dart' as mu;
import 'package:e_kantin/size_config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_kantin/constant.dart';

class UserProfileTile extends StatelessWidget {
  final mu.User user;
  const UserProfileTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Iconsax.user,
        color: kSecondaryColor,
      ),
      title: Text(
        user.name,
        style: GoogleFonts.poppins(
          fontSize: getProportionateScreenHeight(18),
          fontWeight: FontWeight.bold,
          color: kSecondaryColor,
        ),
      ),
      subtitle: Text(
        user.email,
        style: GoogleFonts.poppins(
          fontSize: getProportionateScreenHeight(14),
          color: kSecondaryColor,
        ),
      ),
    );
  }
}
