import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStarWidget extends StatefulWidget {
  final bool onUpdate;
  final bool onUserRating;
  final bool isTextNeeded;
  final double? initialRatingCount;
  final Function(double?)? onRatingPlace;
  final Color? unRatedColor;
  final Color? ratedColor;
  const RatingStarWidget({
    super.key,
    this.onUpdate = false,
    this.onUserRating = false,
    this.isTextNeeded = false,
    this.initialRatingCount,
    this.onRatingPlace,
    this.unRatedColor,
    this.ratedColor,
  });

  @override
  State<RatingStarWidget> createState() => _RatingStarWidgetState();
}

class _RatingStarWidgetState extends State<RatingStarWidget> {
  double? ratingCount = 0;
  double? initailRating;

  @override
  void initState() {
    initailRating = widget.initialRatingCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.onUserRating == true
            ? Text(
                '${ratingCount == 0 ? initailRating ?? 0 : ratingCount}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              )
            : const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: widget.initialRatingCount ?? 0,
              unratedColor: widget.unRatedColor ?? Colors.yellow.shade500,
              glow: false,
              allowHalfRating: true,
              itemBuilder: (context, index) {
                return Icon(
                  Icons.star_rounded,
                  color: widget.ratedColor ?? const  Color(0xFFFFD711),
                );
              },
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
                setState(() {
                  initailRating = rating;
                  ratingCount = rating;
                  widget.onRatingPlace!(ratingCount);
                });
              },
            ),
            const SizedBox(
              width: 8,
            ),
            widget.onUpdate == true
                ? widget.isTextNeeded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          '($initailRating)',
                          style: const TextStyle(fontSize: 18),
                        ))
                    : Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          '($ratingCount)',
                          style: const TextStyle(fontSize: 20),
                        ))
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
