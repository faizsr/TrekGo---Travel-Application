import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trekmate_project/screens/Admin/update_place_screen.dart';
import 'package:trekmate_project/service/database_service.dart';
import 'package:trekmate_project/widgets/place_detail_widget/bottom_buttons.dart';
import 'package:trekmate_project/widgets/reusable_widgets/card_rating_bar.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String? placeid;
  final bool? isAdmin;
  final bool? isUser;
  const PlaceDetailScreen({
    super.key,
    this.placeid,
    this.isAdmin,
    this.isUser,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with TickerProviderStateMixin {
  late Stream<DocumentSnapshot> _destinationData;

  @override
  void initState() {
    super.initState();
    _destinationData =
        DatabaseService().getdestinationData(widget.placeid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ============ Appbar ============
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.11),
        child: Container(
          margin: const EdgeInsets.only(
            top: 45,
            left: 45,
            right: 45,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 7.0,
                sigmaY: 4.0,
              ),
              child: AppBar(
                title: const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.keyboard_backspace_rounded,
                    color: Colors.black,
                  ),
                ),
                // actions: [
                //   Padding(
                //     padding: const EdgeInsets.only(right: 10),
                //     child: Icon(
                //       MdiIcons.dotsVertical,
                //       color: Colors.black,
                //       size: 20,
                //     ),
                //   ),
                // ],
                backgroundColor: Colors.white24,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),

      // ============ Body ============
      body: StreamBuilder(
        stream: _destinationData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var destinationSnapshot =
                snapshot.data?.data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(top: 25),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ============ Place Image ============
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          left: 25,
                          right: 25,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                destinationSnapshot['place_image'] ?? ''),
                          ),
                        ),
                      ),

                      // ============ Place Title ============
                      Text(
                        destinationSnapshot['place_name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CardRatingBar(
                        itemSize: 20,
                        isMainAlignCenter: true,
                        ratingCount: destinationSnapshot['place_rating'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x0D000000),
                      ),

                      // ============ Tab Bar Heading ============
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.035,
                        child: TabBar(
                          physics: const BouncingScrollPhysics(),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          splashFactory: NoSplash.splashFactory,
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding: const EdgeInsets.all(0),
                          indicatorColor: const Color(0xFF1285b9),
                          labelColor: const Color(0xFF1285b9),
                          unselectedLabelColor: Colors.grey,
                          controller: tabController,
                          tabs: const [
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Rate',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        color: Color(0x0D000000),
                      ),

                      // ============ Tab Bar Views ============
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.355,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(
                                      destinationSnapshot['place_description'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  const Divider(
                                    height: 30,
                                    thickness: 1,
                                    color: Color(0x0D000000),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 30,
                                          color: Color(0xFF1285b9),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            destinationSnapshot[
                                                'place_location'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Center(
                              child: Text('Rating section'),
                            ),
                            const Center(
                              child: Text('Review section'),
                            ),
                          ],
                        ),
                      ),

                      const Divider(
                        height: 0,
                        thickness: 1,
                        color: Color(0x0D000000),
                      ),

                      // ============ Bottom buttons ============
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: widget.isAdmin == true
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.center,
                          children: [
                            // ===== Checking if its admin =====
                            widget.isAdmin == true
                                ? const BottomButtons(
                                    widthValue: 3.6,
                                    buttonText: 'Get Direction',
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    child: const BottomButtons(
                                      widthValue: 2.3,
                                      buttonText: 'Get Direction',
                                    ),
                                  ),

                            // ===== Checking if its admin =====
                            widget.isAdmin == true
                                ? BottomButtons(
                                    onPressed: () async {
                                      await onUpdateDetails(
                                        image:
                                            destinationSnapshot['place_image'],
                                        category: destinationSnapshot[
                                            'place_category'],
                                        state:
                                            destinationSnapshot['place_state'],
                                        title:
                                            destinationSnapshot['place_name'],
                                        description: destinationSnapshot[
                                            'place_description'],
                                        location: destinationSnapshot[
                                            'place_location'],
                                        rating:
                                            destinationSnapshot['place_rating'],
                                      );
                                    },
                                    widthValue: 3.4,
                                    buttonText: 'Update Place',
                                  )
                                : const BottomButtons(
                                    widthValue: 2.3,
                                    buttonText: 'Save Place',
                                  ),

                            // ===== Checking if its admin =====
                            widget.isAdmin == true
                                ? BottomButtons(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Are you sure want to delete'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await deleteData(
                                                    widget.placeid ?? '');
                                                debugPrint(
                                                    'Deleted successfully');
                                              },
                                              child: const Text('Yes'),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    widthValue: 3.3,
                                    buttonText: 'Remove Place',
                                  )
                                : const SizedBox(
                                    width: 0,
                                    height: 0,
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  onUpdateDetails({
    String? image,
    String? category,
    String? state,
    String? title,
    String? description,
    String? location,
    double? rating,
  }) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UpdatePlaceScreen(
        placeid: widget.placeid,
        placeImage: image,
        placeCategory: category,
        placeState: state,
        placeTitle: title,
        placeDescription: description,
        placeLocation: location,
        placeRating: rating,
      ),
    ));
  }

  Future<void> deleteData(String placeid) async {
    await DatabaseService().destinationCollection.doc(placeid).delete();
  }
}