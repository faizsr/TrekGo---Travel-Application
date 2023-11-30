import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trekmate_project/model/saved.dart';
import 'package:trekmate_project/widgets/saved_screen_widgets/saved_screen_card.dart';
import 'package:trekmate_project/widgets/saved_screen_widgets/saved_icon.dart';

class SavedPlacesScreen extends StatefulWidget {
  final String userId;
  final bool? isAdmin;
  final bool? isUser;
  const SavedPlacesScreen({
    super.key,
    required this.userId,
    required this.isAdmin,
    required this.isUser,
  });

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  late Box<Saved> savedBox;
  // List<Saved>? savedList;
  String? hiveId;

  @override
  void initState() {
    super.initState();
    savedBox = Hive.box('saved');
    // savedList = savedBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    // final savedPlaces = savedList!.toList();
    return ValueListenableBuilder(
      valueListenable: savedBox.listenable(),
      builder: (context, Box<Saved> savedBox, child) {
        var savedPlaces = savedBox.values
            .where((saved) => saved.userId == widget.userId)
            .toList();
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.12),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFe5e6f6),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.02,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      bottom: 20,
                      child: Text(
                        'Saved Places',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1285b9),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: SizedBox(
                        width: 60,
                        height: 65,
                        child: SavedIcon(
                          biggerIcon: true,
                          // isSaved: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: savedPlaces.isEmpty
              ? GestureDetector(
                  onTap: () {
                    debugPrint('saved places is empty: ${savedPlaces.isEmpty}');
                  },
                  child: const Center(
                    child: Text('No Saved Places'),
                  ),
                )
              : ListView.builder(
                  itemCount: savedPlaces.length,
                  itemBuilder: (context, index) {
                    final saved = savedPlaces[index];
                    debugPrint('id on saved screennnn: ${saved.firebaseid}');
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SavedScreenCard(
                        index: index,
                        userId: widget.userId,
                        isAdmin: widget.isAdmin,
                        isUser: widget.isUser,
                        placeid: saved.firebaseid,
                        popularCardImage: saved.image,
                        placeName: saved.name,
                        ratingCount: saved.rating,
                        placeDescripton: saved.description,
                        placeLocation: saved.location,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
