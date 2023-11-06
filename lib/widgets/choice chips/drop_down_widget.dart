import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final double? leftPadding;
  final double? rightPadding;
  final bool listSelect;
  final Function(String?)? onCategorySelectionChange;
  final Function(String?)? onStateCelectionChange;
  final String? Function(String?)? validator;
  const DropDownWidget({
    super.key,
    this.leftPadding,
    this.rightPadding,
    this.listSelect = false,
    this.onCategorySelectionChange,
    this.onStateCelectionChange,
    this.validator,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  final categoryList = ['Popular', 'Recommended'];
  final stateList = [
    'Kerala',
    'Karnataka',
    'Goa',
    'Maharashtra',
    'Tamil Nadu',
    'Sikkim'
  ];
  String? selectedCategory;
  String? selectedState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.1,
      child: DropdownButtonFormField(
        validator: widget.validator,
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.only(
          left: widget.leftPadding ?? 0,
          right: widget.rightPadding ?? 0,
        ),
        // dropdownColor: Colors.amber,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 3,
            top: 16,
            bottom: 13,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 2.0,
            ),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        hint: const Text(
          'Select category',
          style: TextStyle(
            fontSize: 14,
            color: Color(0x66000000),
            fontWeight: FontWeight.w500,
          ),
        ),
        value: selectedCategory,
        items: widget.listSelect
            ? categoryList.map((newValue) {
                return DropdownMenuItem(
                  value: newValue,
                  child: Text(newValue),
                );
              }).toList()
            : stateList.map((newValue) {
                return DropdownMenuItem(
                  value: newValue,
                  child: Text(newValue),
                );
              }).toList(),
        onChanged: (newValue) {
          widget.listSelect
              ? setState(() {
                  selectedCategory = newValue.toString();
                  debugPrint(selectedCategory);
                  widget.onCategorySelectionChange!(selectedCategory);
                })
              : setState(() {
                  selectedState = newValue.toString();
                  debugPrint(selectedState);
                  widget.onStateCelectionChange!(selectedState);
                });
        },
      ),
    );
  }
}
