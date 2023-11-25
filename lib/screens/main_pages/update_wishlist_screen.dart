import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trekmate_project/model/wishlist.dart';
import 'package:trekmate_project/widgets/alerts_and_navigators/alerts_and_navigates.dart';
import 'package:trekmate_project/widgets/chips_and_drop_downs/drop_down_widget.dart';
import 'package:trekmate_project/widgets/home_screen_widgets/pop_and_recd_appbar.dart';
import 'package:trekmate_project/widgets/reusable_widgets/app_update_image_widget.dart';
import 'package:trekmate_project/widgets/reusable_widgets/section_titles.dart';
import 'package:trekmate_project/widgets/reusable_widgets/text_form_field.dart';

class UpdateWishlistScreen extends StatefulWidget {
  final String? hiveKey;
  final String? userId;
  final String? image;
  final String? name;
  final String? state;
  final String? description;
  final String? location;
  const UpdateWishlistScreen({
    super.key,
    this.hiveKey,
    this.userId,
    this.image,
    this.name,
    this.state,
    this.description,
    this.location,
  });

  @override
  State<UpdateWishlistScreen> createState() => _UpdateWishlistScreenState();
}

class _UpdateWishlistScreenState extends State<UpdateWishlistScreen> {
  XFile? _selectedImage;
  String? selectedState;
  String? initialState;
  String? imageUrl;
  late Box<Wishlist> wishlistBox;
  List<Wishlist>? filteredPlace;

  void updateStateSelection(String? category) {
    selectedState = category;
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    wishlistBox = Hive.box('wishlists');
    filteredPlace = wishlistBox.values.toList();
    nameController.text = widget.name ?? '';
    descriptionController.text = widget.description ?? '';
    locationController.text = widget.location ?? '';
    initialState = widget.state;
    imageUrl = widget.image.toString();
    debugPrint('index on update wishlist: ${widget.hiveKey}');
    debugPrint('user id on update wishlist: ${widget.userId}');
  }

  void updateDataInHive() {
    setState(() {
      filteredPlace = wishlistBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Appbar =====
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size * 0.1,
        child: PlaceScreenAppbar(
          title: 'Update Wishlist',
          isLocationEnable: false,
          showCheckIcon: true,
          onTap: () => updateData(),
        ),
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddUpdateImageContainer(
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(File(_selectedImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: FileImage(File(widget.image.toString())),
                        fit: BoxFit.cover,
                      ),
                onPressed: () async {
                  XFile? pickedImage = await pickImageFromGallery();
                  setState(() {
                    _selectedImage = pickedImage;
                  });
                },
              ),

              // ===== State =====
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: SectionTitles(
                  titleText: 'State',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DropDownWidget(
                  updateState: initialState,
                  updateCategory: '',
                  hintText: 'Select State',
                  rightPadding: 20,
                  leftPadding: 20,
                  onStateCelectionChange: updateStateSelection,
                  validator: (val) {
                    if (val == null) {
                      customSnackbar(
                          context, 'Please select a category', 20, 20, 20);
                      return 'This field is required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              // ===== Title section =====
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: SectionTitles(
                  titleText: 'Title',
                ),
              ),
              TextFieldWidgetTwo(
                controller: nameController,
                hintText: 'Title of the place...',
                minmaxLine: false,
                validator: (val) {
                  if (val!.isEmpty) {
                    customSnackbar(context, 'Title is required', 20, 20, 20);
                    return;
                  } else {
                    return null;
                  }
                },
              ),

              // ===== Description section =====
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: SectionTitles(titleText: 'Description'),
              ),
              TextFieldWidgetTwo(
                controller: descriptionController,
                hintText: 'Description of the place...',
                minmaxLine: true,
                validator: (val) {
                  if (val!.isEmpty) {
                    customSnackbar(
                        context, 'Description is required', 20, 20, 20);
                    return;
                  } else {
                    return null;
                  }
                },
              ),

              // ===== Location section =====
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: SectionTitles(
                  titleText: 'Location',
                ),
              ),
              TextFieldWidgetTwo(
                controller: locationController,
                hintText: 'Location of the place...',
                minmaxLine: false,
                validator: (val) {
                  if (val!.isEmpty) {
                    customSnackbar(context, 'Location is required', 20, 20, 20);
                    return;
                  } else {
                    return null;
                  }
                },
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Function for image picking from gallery =====
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return XFile(pickedImage.path);
    }
    return null;
  }

  updateData() {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        initialState != null &&
        imageUrl != null) {
      wishlistBox.put(
          widget.hiveKey ?? '',
          Wishlist(
            userId: widget.userId,
            hiveKey: widget.hiveKey,
            image: _selectedImage?.path ?? widget.image,
            state: selectedState ?? initialState,
            name: nameController.text,
            description: descriptionController.text,
            location: locationController.text,
          ));
      setState(() {
        updateDataInHive();
        debugPrint('Updated in hive');
      });
      debugPrint('Updated at hive key ${widget.hiveKey}');
    }
  }
}
