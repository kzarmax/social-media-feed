import 'package:feed/models/comment_model.dart';
import 'package:feed/theme/theme_util.dart';
import 'package:feed/utils/database_provider.dart';
import 'package:feed/utils/extensions.dart';
import 'package:feed/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  final int post_id;

  const CommentPage({super.key, required this.post_id});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseProvider _databaseProvider = DatabaseProvider.db;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentNode = FocusNode();

  final List<CommentModel> _comments = [];
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    setOrientationPortrait();
    _getComments();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _contentController.dispose();
    _contentNode.dispose();
    super.dispose();
  }

  _getComments() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      List<CommentModel> lists = [];
      var result = await _databaseProvider.getComments(widget.post_id);
      for (var item in result["items"]) {
        lists.add(CommentModel.fromJson(item));
      }
      setState(() {
        _comments.addAll(lists);
        _isLoading = false;
      });
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      _errorHandler();
    }
  }

  _errorHandler() {
    setState(() {
      _isError = true;
      _isLoading = false;
    });
  }

  Future<bool> _backHandler() async {
    Helper.finish(context, _comments.length);
    return false;
  }

  _addComment() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String content = _contentController.text.trim();
    if (content.isEmpty) return;
    Map<String, dynamic> record = {
      "post_id": widget.post_id,
      "content": content,
    };
    int newId = await _databaseProvider.insertComment(record);
    var newItem = await _databaseProvider.getComment(newId);
    if (newItem != null) {
      setState(() {
        _comments.add(CommentModel.fromJson(newItem));
      });
    }
    _contentController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backHandler,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarPrimaryColor,
          title: Text(
            "Add Comment",
            style: primaryTextStyle(bold: true).copyWith(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              constraints: const BoxConstraints.expand(),
              color: appBackgroundColor,
              child: _isError
                  ? Container(
                      constraints: const BoxConstraints.expand(),
                      alignment: Alignment.center,
                      child: Text(
                        "Something went wrong",
                        style: primaryTextStyle(bold: true).copyWith(fontSize: 18.sp),
                      ),
                    )
                  : !_isLoading
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                itemCount: _comments.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: SizedBox(
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
                                    title: Text(
                                      _comments[index].content,
                                      style: primaryTextStyle(),
                                    ),
                                    subtitle: Text(
                                      timeago.format(DateTime.parse(_comments[index].created_at)),
                                      style: secondaryTextStyle(),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "0",
                                              style: secondaryTextStyle(),
                                            ),
                                            5.height,
                                            InkWell(
                                              onTap: () {
                                                Helper.showToast("Coming noon...", true);
                                              },
                                              child: const Icon(Icons.thumb_up),
                                            )
                                          ],
                                        ),
                                        10.width,
                                        Column(
                                          children: [
                                            Text(
                                              "0",
                                              style: secondaryTextStyle(),
                                            ),
                                            5.height,
                                            InkWell(
                                              onTap: () {
                                                Helper.showToast("Coming noon...", true);
                                              },
                                              child: const Icon(Icons.thumb_down),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 60.h,
                              color: appBackgroundColor,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                heightFactor: 0.75,
                                child: TextField(
                                  focusNode: _contentNode,
                                  controller: _contentController,
                                  style: primaryTextStyle(),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "Add Comment",
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    contentPadding: EdgeInsets.only(left: 15.w, right: 0, top: 5.h, bottom: 5.h),
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _addComment();
                                      },
                                      padding: EdgeInsets.zero,
                                      splashRadius: 40.h,
                                      icon: const Icon(Icons.send, color: textSecondaryColor),
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    _addComment();
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      : const Loading(),
            ),
          ),
        ),
      ),
    );
  }
}
