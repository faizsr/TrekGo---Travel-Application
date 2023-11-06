import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trekmate_project/assets.dart';
import 'package:trekmate_project/widgets/Reusable%20widgets/place_cards.dart';

class FirebasePopularCarouselSlider extends StatefulWidget {
  const FirebasePopularCarouselSlider({super.key});

  @override
  State<FirebasePopularCarouselSlider> createState() => _FirebasePopularCarouselSliderState();
}

class _FirebasePopularCarouselSliderState extends State<FirebasePopularCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.7,
      child: CarouselSlider(
        items: [
          PopularCard(popularCardImage: munnar),
          PopularCard(popularCardImage: varkala),
          PopularCard(popularCardImage: jewTown),
          PopularCard(popularCardImage: vythiri),
          PopularCard(popularCardImage: athirapally),
        ],
        options: CarouselOptions(
          scrollPhysics: const BouncingScrollPhysics(),
          viewportFraction: 1.0,
          pauseAutoPlayInFiniteScroll: true,
          height: MediaQuery.of(context).size.height / 2.95,
          // enlargeStrategy: CenterPageEnlargeStrategy.height,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          // autoPlay: true,
          autoPlayAnimationDuration: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
