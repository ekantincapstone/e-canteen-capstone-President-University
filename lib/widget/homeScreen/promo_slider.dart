import 'package:e_kantin/constant.dart';
import 'package:e_kantin/widget/container/rounded_image.dart';
import 'package:e_kantin/widget/homeScreen/home_controller.dart';
import 'package:e_kantin/widget/container/circular_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_kantin/size_config.dart'; // Impor SizeConfig untuk ukuran proporsional

class PromoSlider extends StatelessWidget {
  const PromoSlider({
    super.key,
    required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: getProportionateScreenHeight(200), // Sesuaikan tinggi
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
          ),
          items: banners.map((url) {
            return Padding(
              padding: EdgeInsets.all(
                  getProportionateScreenWidth(8)), // Padding proporsional
              child: RoundedImage(imageUrl: url),
            );
          }).toList(),
        ),
        SizedBox(
          height: getProportionateScreenHeight(16), // Spasi antar elemen
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < banners.length; i++)
                CircularContainer(
                  width:
                      getProportionateScreenWidth(20), // Indikator proporsional
                  height: getProportionateScreenHeight(4),
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        getProportionateScreenWidth(5), // Margins proporsional
                  ),
                  backgroundColor: controller.carouselCurrentIndex.value == i
                      ? kMainColor
                      : Colors.grey,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
