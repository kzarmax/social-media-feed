import 'package:cached_network_image/cached_network_image.dart';
import 'package:feed/models/post_model.dart';
import 'package:feed/pages/main_page/sub_pages/comment_page.dart';
import 'package:feed/pages/main_page/sub_pages/post_detail_page.dart';
import 'package:feed/theme/src/colors.dart';
import 'package:feed/theme/src/decoration.dart';
import 'package:feed/theme/src/widgets.dart';
import 'package:feed/utils/extensions.dart';
import 'package:feed/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatelessWidget {
  final PostModel post;
  final IntCallback onUpdateComment;
  final VoidCallback onAddFavorite;
  final VoidCallback onRemoveFavorite;

  const PostItem({
    super.key,
    required this.post,
    required this.onUpdateComment,
    required this.onAddFavorite,
    required this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: Colors.black26, width: 1.w),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.w),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            PostDetailPage(
              post: post,
            ).launch(
              context,
              isNewTask: false,
              type: PageTransitionType.fade,
            );
          },
          borderRadius: BorderRadius.circular(10.w),
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
                          Text(post.author == "" ? "Unknown" : post.author, style: primaryTextStyle(bold: true)),
                          3.height,
                          Text(
                            timeago.format(DateTime.parse(post.created_at)),
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
              SizedBox(
                height: 300.h,
                child: Hero(
                  tag: "post_image_${post.id}",
                  child: CachedNetworkImage(
                    imageUrl: post.image,
                    placeholder: (context, url) => CupertinoActivityIndicator(radius: 10.w),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              20.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Hero(
                  tag: "post_title_${post.id}",
                  child: Text(
                    post.title,
                    style: primaryTextStyle(bold: true),
                  ),
                ),
              ),
              20.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40.w),
                        child: Text(
                          "${post.comment} comments",
                          style: secondaryTextStyle().copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${post.favorite} likes",
                          style: secondaryTextStyle().copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              5.height,
              VerticalBorder(height: 1.h, color: Colors.black26),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.w),
                        onTap: () {
                          CommentPage(
                            post_id: post.id,
                          ).launch(context, isNewTask: false, type: PageTransitionType.rightToLeft).then((value) => onUpdateComment(value));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: Center(
                                child: Icon(
                                  Icons.comment,
                                  size: 20.sp,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            7.width,
                            Text(
                              "COMMENT",
                              style: primaryTextStyle(bold: true),
                            )
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.w),
                        onTap: () {
                          post.favorite == 1 ? onRemoveFavorite() : onAddFavorite();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20.sp,
                              color: post.favorite == 1 ? Colors.pinkAccent : Colors.black38,
                            ),
                            7.width,
                            Text(
                              "LIKE",
                              style: primaryTextStyle(bold: true),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
