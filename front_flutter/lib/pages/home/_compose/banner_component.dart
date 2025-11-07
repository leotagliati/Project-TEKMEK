import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter/pages/home/_compose/banner_subcomponent.dart';
import 'package:front_flutter/utils/breakpoints.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({super.key});

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final carouselController = CarouselSliderController();
  int current = 0;

  final List<Widget> banners = [
    BannerSubcomponent(
      imageUrl:
          'https://images.pexels.com/photos/13094372/pexels-photo-13094372.jpeg',
      title: 'Seu setup, suas regras',
      description: 'Switches, keycaps e bases para um teclado único',
    ),
    BannerSubcomponent(
      imageUrl:
          'https://images.pexels.com/photos/17479950/pexels-photo-17479950.jpeg',
      title: 'Monte. Modifique. Domine.',
      description: 'Liberdade total com teclados hot-swappable',
    ),
    BannerSubcomponent(
      imageUrl:
          'https://images.pexels.com/photos/6782533/pexels-photo-6782533.jpeg',
      title: 'Design que Inspira',
      description: 'A peça central que faltava na sua mesa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        CarouselSlider(
          items: banners,
          carouselController: carouselController,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width > breakpointMobile
                ? 320
                : MediaQuery.of(context).size.width > 460
                ? 200
                : 240,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1200),
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                current = current = index;
              });
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: banners.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        (Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white)
                            .withOpacity(current == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
