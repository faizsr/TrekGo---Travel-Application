import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trekmate_project/service/database_service.dart';
import 'package:trekmate_project/widgets/reusable_widgets/place_cards.dart';

class PopularPlacesScreen extends StatefulWidget {
  final bool? isAdmin;
  final bool? isUser;
  final String? sortName;
  const PopularPlacesScreen({
    super.key,
    this.isAdmin,
    this.isUser,
    this.sortName,
  });

  @override
  State<PopularPlacesScreen> createState() => _PopularPlacesScreenState();
}

class _PopularPlacesScreenState extends State<PopularPlacesScreen> {
  double? ratingCount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Appbar =====
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(
              Icons.keyboard_backspace_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.mapMarkerOutline,
                      size: 12,
                      color: Colors.black,
                    ),
                    widget.sortName == 'View All'
                        ? const Text(
                            'India',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                        : Text(
                            '${widget.sortName ?? 'Welcome to'}, India',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: const Color(0xFFe5e6f6),
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        // ===== Popular places =====
        child: StreamBuilder(
          // ===== Sorting data based on chip selection =====
          stream: widget.sortName == 'View All'
              ? DatabaseService()
                  .destinationCollection
                  .where('place_category', isEqualTo: 'Popular')
                  .snapshots()
              : DatabaseService()
                  .destinationCollection
                  .where('place_category', isEqualTo: 'Popular')
                  .where('place_state', isEqualTo: widget.sortName)
                  .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data.docs
                    .map<Widget>((DocumentSnapshot destinationSnap) {
                  ratingCount = double.tryParse(
                      destinationSnap['place_rating'].toString());
                  return Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: PopularCard(
                      isAdmin: widget.isAdmin,
                      isUser: widget.isUser,
                      placeid: destinationSnap.id,
                      placeName: destinationSnap['place_name'],
                      popularCardImage: destinationSnap['place_image'],
                      placeCategory: destinationSnap['place_category'],
                      placeState: destinationSnap['place_state'],
                      ratingCount: ratingCount,
                      placeDescripton: destinationSnap['place_description'],
                      placeLocation: destinationSnap['place_location'],
                    ),
                  );
                }).toList(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}