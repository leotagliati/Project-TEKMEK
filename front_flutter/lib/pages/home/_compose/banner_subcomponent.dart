import 'package:flutter/material.dart';
import 'package:front_flutter/utils/breakpoints.dart';

class BannerSubcomponent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const BannerSubcomponent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(color: const Color.fromARGB(125, 0, 0, 0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.width > breakpointMobile
                          ? 32
                          : 24,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0,
                          color: const Color.fromARGB(125, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.width > breakpointMobile
                          ? 20
                          : 16,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0,
                          color: const Color.fromARGB(125, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
