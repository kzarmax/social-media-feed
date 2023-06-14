import 'package:feed/theme/theme_util.dart';
import 'package:feed/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final int selected;
  final IntCallback onFinish;

  const SearchFilterBottomSheet({
    super.key,
    required this.selected,
    required this.onFinish,
  });

  @override
  State<SearchFilterBottomSheet> createState() => _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {

  int _selected = -1;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ValueChanged<int> _filterChangeHandler() {
    return (value) => setState(() {
      _selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sort by",
                style: primaryTextStyle(bold: true).copyWith(fontSize: 16.sp),
              ),
              SizedBox(
                width: 30.w,
                height: 30.w,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear, color: textPrimaryColor),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  splashRadius: 20.w,
                ),
              ),
            ],
          ),
          15.height,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioWidget<int>(value: 0, groupValue: _selected, label: "All", onChanged: _filterChangeHandler()),
                RadioWidget<int>(value: 1, groupValue: _selected, label: "Date published", onChanged: _filterChangeHandler()),
                RadioWidget<int>(value: 2, groupValue: _selected, label: "Author name", onChanged: _filterChangeHandler()),
                RadioWidget<int>(value: 3, groupValue: _selected, label: "Trending", onChanged: _filterChangeHandler()),
              ],
            ),
          ),
          10.height,
          SizedBox(
            width: double.infinity,
            height: 60.h,
            child: ElevatedButton(
              onPressed: () {
                widget.onFinish(_selected);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.h),
                ),
              ),
              child: Text("Search", style: whiteTextStyle(bold: true)),
            ),
          ),
          20.height,
        ],
      ),
    );
  }
}
