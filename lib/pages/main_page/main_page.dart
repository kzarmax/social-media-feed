import 'dart:math';

import 'package:feed/models/post_model.dart';
import 'package:feed/pages/main_page/overlay/search_filter_sheet.dart';
import 'package:feed/pages/main_page/widgets/post_item.dart';
import 'package:feed/utils/database_provider.dart';
import 'package:feed/utils/helper.dart';
import 'package:feed/utils/search_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../theme/theme_util.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseProvider _databaseProvider = DatabaseProvider.db;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  List<PostModel> _posts = [];

  bool _isShowClearButton = false;
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isInit = false;
  bool _isError = false;

  int _filter = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    setOrientationPortrait();
    _filter = SearchHelper.filter;
    _getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchNode.dispose();
    super.dispose();
  }

  _getPosts() async {
    String keyword = _searchController.text.trim();
    try {
      if (_hasNextPage) {
        List<PostModel> lists = [];
        var result = await _databaseProvider.getPosts(_currentPage, keyword, _filter);
        await Helper.sleep(1200);
        _hasNextPage = result["hasNext"];
        _currentPage++;
        for (var item in result["items"]) {
          lists.add(PostModel.fromJson(item));
        }
        if (!_isInit) {
          _isInit = true;
        }
        if (mounted) {
          setState(() {
            _posts.addAll(lists);
          });
        }
      }
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
    });
  }

  _addFavorite(int index, int postId) async {
    Map<String, dynamic> update = {
      "favorite": 1,
    };
    bool success = await _databaseProvider.updatePost(update, postId);
    if (success) {
      setState(() {
        _posts[index].favorite = 1;
      });
    }
  }

  _removeFavorite(int index, int postId) async {
    Map<String, dynamic> update = {
      "favorite": 0,
    };
    bool success = await _databaseProvider.updatePost(update, postId);
    if (success) {
      setState(() {
        _posts[index].favorite = 0;
      });
    }
  }

  _handleSearchFilter() {
    showModalBottomSheet(
      context: context,
      elevation: 10,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 0.4.sh),
      enableDrag: false,
      useSafeArea: true,
      backgroundColor: appBackgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
      ),
      builder: (_) => SearchFilterBottomSheet(
        selected: _filter,
        onFinish: (value) {
          _filter = value;
          SearchHelper.filter = value;
          _onSearch();
        },
      ),
    );
  }

  _onSearch() {
    _currentPage = 1;
    _isInit = false;
    _hasNextPage = true;
    _isError = false;
    _posts = [];
    setState(() {});
    _getPosts();
  }

  Future<bool> _backHandler() async {
    Helper.showExitDialog(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backHandler,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarPrimaryColor,
          leading: const Icon(Icons.menu, color: Colors.white),
          leadingWidth: 40.w,
          titleSpacing: 10.w,
          title: TextField(
            focusNode: _searchNode,
            controller: _searchController,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            keyboardType: TextInputType.text,
            onSubmitted: (_) {
              _onSearch();
            },
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  _isShowClearButton = value.isNotEmpty;
                });
              }
            },
            style: primaryTextStyle(),
            decoration: textInputDecoration(hint: "Search Keyword").copyWith(
                constraints: const BoxConstraints(maxHeight: 40),
                prefixIcon: SizedBox(
                  width: 35.w,
                  child: Icon(
                    Icons.search,
                    size: 28.w,
                  ),
                ),
                suffixIcon: _isShowClearButton
                    ? Transform.rotate(
                        angle: 45 * pi / 180,
                        child: IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.grey),
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 50)).then((_) {
                              _searchController.clear();
                              _onSearch();
                            });
                            _isShowClearButton = false;
                          },
                        ),
                      )
                    : null),
          ),
          actions: [
            IconButton(
              onPressed: _handleSearchFilter,
              icon: const Icon(Icons.filter_alt),
              padding: EdgeInsets.zero,
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: _isError
                ? Container(
                    constraints: const BoxConstraints.expand(),
                    alignment: Alignment.center,
                    child: Text(
                      "Something went wrong",
                      style: primaryTextStyle(bold: true).copyWith(fontSize: 18.sp),
                    ),
                  )
                : _isInit
                    ? _posts.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text("No Posts", style: primaryTextStyle(bold: true)),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _posts.length + 1,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == _posts.length) {
                                return SizedBox(
                                  height: _hasNextPage ? 40 : 0,
                                  child: _hasNextPage ? const SpinKitDualRing(size: 25, lineWidth: 2, color: Colors.black) : null,
                                );
                              } else {
                                return PostItem(
                                  post: _posts[index],
                                  onUpdateComment: (value) {
                                    setState(() {
                                      _posts[index].comment = value;
                                    });
                                  },
                                  onAddFavorite: () {
                                    _addFavorite(index, _posts[index].id);
                                  },
                                  onRemoveFavorite: () {
                                    _removeFavorite(index, _posts[index].id);
                                  },
                                );
                              }
                            },
                          )
                    : const Loading(),
          ),
        ),
      ),
    );
  }
}
