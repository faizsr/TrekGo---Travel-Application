import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trekmate_project/assets.dart';
import 'package:trekmate_project/widgets/appbar_title_items.dart';
import 'package:trekmate_project/widgets/Reusable%20widgets/rating_star.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Place Image

            Container(
              margin: const EdgeInsets.only(
                  bottom: 20, left: 25, right: 25, top: 25),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(cubbonPark),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 15,
                    left: 20,
                    right: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 7.0,
                          sigmaY: 4.0,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: Offset(0, 2),
                                spreadRadius: 4,
                                color: Color(0x1A000000),
                              ),
                            ],
                            color: Colors.white60,
                          ),
                          child: const AppbarTitleItems(
                            appbarTitleText: 'Details',
                            iconSize: 25,
                            titleSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Place Title

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Cubbon Park',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: const RatingStar(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
              color: Color(0x0D000000),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1285b9),
                    ),
                  ),
                  Text(
                    'Rate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Reveiws',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 30,
              thickness: 1,
              color: Color(0x0D000000),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                "Cubbon Park, officially known as Sri Chamarajendra Park, is a beautiful and expansive urban park located in the heart of Bangalore, the capital of the Indian state of Karnataka. Named after Sir Mark Cubbon, a British civil servant who served as the Commissioner of Mysore in the 19th century, the park is a green oasis amidst the bustling city.",
                style: TextStyle(fontSize: 13),
              ),
            ),

            const Divider(
              height: 30,
              thickness: 1,
              color: Color(0x0D000000),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 30,
                    color: Color(0xFF1285b9),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      "Kasturba Rd, behind High Court of Karnataka, Ambedkar Veedhi, Sampangi Rama Nagara, Bengaluru, Karnataka 560001",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 30,
              thickness: 1,
              color: Color(0x0D000000),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: const Color(0xFFe5e6f6),
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Text(
                        'Get Direction',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: const Color(0xFFe5e6f6),
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Text(
                        'Save Place',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
