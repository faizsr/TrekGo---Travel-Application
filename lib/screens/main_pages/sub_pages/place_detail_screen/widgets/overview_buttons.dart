import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:trekgo_project/model/saved.dart';
import 'package:trekgo_project/screens/admin/update_place_screen.dart';
import 'package:trekgo_project/service/database_service.dart';
import 'package:trekgo_project/screens/main_pages/sub_pages/place_detail_screen/widgets/bottom_buttons.dart';
import 'package:trekgo_project/provider/saved_provider.dart';
import 'package:trekgo_project/widgets/reusable_widgets/alerts_and_navigates.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewBottomButtons extends StatefulWidget {
  final bool? isAdmin;
  final String? mapLink;
  final String? image;
  final String? category;
  final String? state;
  final String? title;
  final String? description;
  final String? location;
  final double? rating;
  final String? placeId;
  final BuildContext? ctx;
  final String? userId;
  const OverviewBottomButtons({
    super.key,
    this.isAdmin,
    this.mapLink,
    this.image,
    this.category,
    this.state,
    this.title,
    this.description,
    this.location,
    this.rating,
    this.placeId,
    this.ctx,
    required this.userId,
  });

  @override
  State<OverviewBottomButtons> createState() => _OverviewBottomButtonsState();
}

class _OverviewBottomButtonsState extends State<OverviewBottomButtons> {
  late Box<Saved> savedBox;

  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    savedBox = Hive.box('saved');
  }

  @override
  Widget build(BuildContext context) {
    var savedProvider = Provider.of<SavedProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 255, 255, 0),
          Color(0xF2f0f3f7),
          Color(0xFFf0f3f7),
          Color(0xFFf0f3f7),
          Color(0xFFf0f3f7),
          Color(0xFFf0f3f7),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 20),
      child: Row(
        mainAxisAlignment: widget.isAdmin == true
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.center,
        children: [
          // ===== Checking if its admin =====
          widget.isAdmin == true
              ? BottomButtons(
                  onPressed: () {
                    openGoogleMap(mapLink: widget.mapLink);
                  },
                  widthValue: 0.3,
                  buttonText: 'Get Direction',
                )
              : Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: BottomButtons(
                    onPressed: () {
                      openGoogleMap(mapLink: widget.mapLink);
                    },
                    widthValue: 0.45,
                    buttonText: 'Get Direction',
                  ),
                ),

          // ===== Checking if its admin =====
          widget.isAdmin == true
              ? BottomButtons(
                  onPressed: () async {
                    await onUpdateDetails(
                      image: widget.image,
                      category: widget.category,
                      state: widget.state,
                      title: widget.title?.replaceAll(RegExp(r'\s+'), ' '),
                      description:
                          widget.description?.replaceAll(RegExp(r'\s+'), ' '),
                      location:
                          widget.location?.replaceAll(RegExp(r'\s+'), ' '),
                      mapLink: widget.mapLink?.replaceAll(RegExp(r'\s+'), ' '),
                      rating: widget.rating,
                      context: widget.ctx,
                    );
                  },
                  widthValue: 0.3,
                  buttonText: 'Update Place',
                )
              : BottomButtons(
                  widthValue: 0.45,
                  buttonText: savedProvider.isExist(widget.placeId ?? '')
                      ? 'Unsave Place'
                      : 'Save Place',
                  onPressed: () async {
                    if (!savedProvider.savedIds.contains(widget.placeId)) {
                      String uniqueKey = widget.placeId ?? '';
                      DateTime dateTime = DateTime.now();
                      await savedBox.put(
                          uniqueKey,
                          Saved(
                              firebaseid: widget.placeId,
                              image: widget.image,
                              name: widget.title,
                              rating: widget.rating,
                              description: widget.description,
                              location: widget.location,
                              dateTime: dateTime));
                      savedProvider.updateSavedIds(
                        savedProvider.savedIds..add(widget.placeId ?? ''),
                      );
                      debugPrint('Added successfully at id: ${widget.placeId}');
                    } else {
                      // int index =
                      //     savedProvider.savedIds.indexOf(widget.placeId ?? '');
                      savedBox.delete(widget.placeId);
                      savedProvider.updateSavedIds(
                        savedProvider.savedIds..remove(widget.placeId),
                      );
                      debugPrint(
                          'Deleted successfully at id: ${widget.placeId}');
                      savedBox.compact();
                    }
                  },
                ),

          // ===== Checking if its admin =====
          widget.isAdmin == true
              ? BottomButtons(
                  onPressed: () async {
                    await deleteDialog(widget.ctx!, widget.placeId);
                  },
                  widthValue: 0.3,
                  buttonText: 'Remove Place',
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }

  openGoogleMap({String? mapLink}) {
    String link = mapLink ?? '';
    Uri uri = Uri.parse(link);
    launchgoogleMap(uri);
  }

  launchgoogleMap(Uri googleMapsUrl) async {
    if (await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  deleteDialog(BuildContext context, String? placeId) async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Delete Place?',
          description: 'This place will be permanently deleted from this list',
          onTap: () async {
            await deleteData(placeId ?? '');
            debugPrint('Deleted successfully');
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> deleteData(String placeid) async {
    await DatabaseService().destinationCollection.doc(placeid).delete();
  }

  onUpdateDetails({
    String? image,
    String? category,
    String? state,
    String? title,
    String? description,
    String? location,
    String? mapLink,
    double? rating,
    BuildContext? context,
  }) async {
    nextScreen(
      context,
      UpdatePlaceScreen(
        placeid: widget.placeId,
        placeImage: image,
        placeCategory: category,
        placeState: state,
        placeTitle: title,
        placeDescription: description,
        placeLocation: location,
        placeRating: rating,
        placeMapLink: mapLink,
      ),
    );
  }
}
