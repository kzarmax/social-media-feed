import 'package:feed/theme/theme_util.dart';
import 'package:feed/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final double size;
  final double opacity;
  final Color background;

  const Loading({
    super.key,
    this.size = 25,
    this.opacity = 0.1,
    this.background = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(color: background.withOpacity(opacity)),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 4)]),
          child: SpinKitRing(
            color: Colors.black,
            lineWidth: 2,
            duration: const Duration(milliseconds: 1000),
            size: size,
          ),
        ),
      ),
    );
  }
}

class HorizonBorder extends StatelessWidget {
  final double width;
  final Color color;

  const HorizonBorder({Key? key, required this.width, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: double.infinity,
      child: Container(
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}

class VerticalBorder extends StatelessWidget {
  final double height;
  final Color color;

  const VerticalBorder({Key? key, required this.height, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}

class RadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const RadioWidget({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  Widget _buildLabel() {
    final bool isSelected = value == groupValue;

    return Container(
      width: 15.w,
      height: 15.w,
      decoration: ShapeDecoration(
        shape: const CircleBorder(side: BorderSide(color: Color(0xFFC9D0D8))),
        color: isSelected ? Colors.deepPurple : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(5.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLabel(),
            10.width,
            Text(
              label,
              style: primaryTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}