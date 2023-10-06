import 'package:flutter/material.dart';

import 'package:pagination/services/api_service.dart';

import '../models/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService service = ApiService();
  final ScrollController _controller = ScrollController();

  List<PostModel> postData = [];
  int page = 1;
  int limit = 10;
  bool _noMoreData = false;

  @override
  void initState() {
    super.initState();
    getPostData();
    _controller.addListener(_loadMore);
  }

  getPostData() async {
    postData = await service.getPost(page, 10);
    setState(() {});
  }

  getLoadMoreData() async {
    List<PostModel> loadMoreData = await service.getPost(page, 10);
    postData = postData + loadMoreData;
    setState(() {});
  }

  void _loadMore() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      page++;
      getLoadMoreData();
      _noMoreData = service.noDataMessage;
      setState(() {});
    } else {
      _noMoreData = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Pagination Test"),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: _controller,
                  itemCount: postData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          color: Colors.white70,
                          child: Column(
                            children: [
                              Text(postData[index].id.toString()),
                              Text(postData[index].title.toString()),
                              Text(postData[index].body.toString()),
                            ],
                          )),
                    );
                  }),
            ),
            service.loading
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            _noMoreData
                ? Container(
                    width: double.infinity,
                    color: Colors.red,
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text("No More Data...")))
                : Container(),
          ],
        ));
  }
}
