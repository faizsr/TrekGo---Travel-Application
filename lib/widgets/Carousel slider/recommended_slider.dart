import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trekmate_project/service/database_service.dart';
import 'package:trekmate_project/widgets/Reusable%20widgets/recommended_card.dart';

class RecommendedPlaceSlider extends StatefulWidget {
  final String? sortName;
  const RecommendedPlaceSlider({
    super.key,
    this.sortName,
  });

  @override
  State<RecommendedPlaceSlider> createState() => _RecommendedPlaceSliderState();
}

class _RecommendedPlaceSliderState extends State<RecommendedPlaceSlider> {
  double? ratingCount;
  @override
  Widget build(BuildContext context) {

    // ===== Recommended places carousel slider =====
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          top: 15,
        ),
        child: StreamBuilder(
          stream: widget.sortName == 'View All'
              ? DatabaseService()
                  .destinationCollection
                  .where('place_category', isEqualTo: 'Recommended')
                  .snapshots()
              : DatabaseService()
                  .destinationCollection
                  .where('place_category', isEqualTo: 'Recommended')
                  .where('place_state', isEqualTo: widget.sortName)
                  .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              return Row(
                children: snapshot.data.docs
                    .map<Widget>((DocumentSnapshot destinationSnap) {
                  ratingCount = double.tryParse(
                      destinationSnap['place_rating'].toString());
                  return RecommendedCard(
                    placeName: destinationSnap['place_name'],
                    ratingCount: double.tryParse(
                        destinationSnap['place_rating'].toString()),
                    placeid: destinationSnap.id,
                    placeCategory: destinationSnap['place_category'],
                    placeState: destinationSnap['place_state'],
                    recommendedCardImage: destinationSnap['place_image'],
                    placeDescription: destinationSnap['place_description'],
                    placeLocation: destinationSnap['place_location'],
                  );
                }).toList(),
              );
            } else {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height / 5.0,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Recommeded is empty for this place',textAlign: TextAlign.center)
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
