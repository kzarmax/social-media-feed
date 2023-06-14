import 'package:cached_network_image/cached_network_image.dart';
import 'package:feed/models/post_model.dart';
import 'package:feed/theme/src/colors.dart';
import 'package:feed/theme/src/decoration.dart';
import 'package:feed/utils/extensions.dart';
import 'package:feed/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, interact) {
              return [
                SliverAppBar(
                  backgroundColor: appBarPrimaryColor,
                  expandedHeight: 300.h,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Hero(
                      tag: "post_title_${widget.post.id}",
                      child: Text(
                        widget.post.title,
                        style: whiteTextStyle(bold: true).copyWith(fontSize: 12.sp),
                      ),
                    ),
                    titlePadding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
                    background: SizedBox(
                      height: 300.h,
                      child: Hero(
                        tag: "post_image_${widget.post.id}",
                        child: CachedNetworkImage(
                          imageUrl: widget.post.image,
                          placeholder: (context, url) => CupertinoActivityIndicator(radius: 10.w),
                          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    stretchModes: const [
                      StretchMode.zoomBackground,
                    ],
                  ),
                )
              ];
            },
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),

              child: Column(
                children: [
                  Container(
                    height: 80.h,
                    padding: EdgeInsets.only(left: 15.w, right: 5.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 2),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.h),
                              child: Image.asset("assets/avatar.png", fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        20.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.post.author == "" ? "Unknown" : widget.post.author, style: primaryTextStyle(bold: true)),
                              3.height,
                              Text(
                                timeago.format(DateTime.parse(widget.post.created_at)),
                                style: secondaryTextStyle().copyWith(
                                  fontSize: 12.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                        10.width,
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Helper.showToast("Coming noon...", true);
                          },
                          icon: Icon(
                            FontAwesomeIcons.share,
                            size: 18.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.height,
                  Text(widget.post.description, style: primaryTextStyle(),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
