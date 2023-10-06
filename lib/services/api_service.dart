import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pagination/models/post_model.dart';

class ApiService {
  final String BASE_URL = "https://jsonplaceholder.typicode.com/posts";

  final int _totalPage = 5;
  bool loading = false;
  bool noDataMessage = false;

  Future<List<PostModel>> getPost(int page, int limit) async {
    loading = true;
    if (_totalPage >= page) {
      final response =
          await http.get(Uri.parse("$BASE_URL?_page=$page&_limit=$limit"));
      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        final List<PostModel> responseData =
            dataList.map((json) => PostModel.fromJson(json)).toList();
        loading = false;
        return responseData;
      } else {
        throw Exception('Failed to load Post');
      }
    } else {
      loading = false;
      noDataMessage = true;
      return [];
    }
  }
}
