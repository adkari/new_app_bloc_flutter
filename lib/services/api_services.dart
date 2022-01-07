import 'dart:convert';
import 'package:news_app/model/article_model.dart';
import 'package:http/http.dart';
import 'package:news_app/secret.dart';

//HTTP request services

class ApiService {
  String endPointUrl =
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey";

  Future<List<Article>> getArticle() async {
    Response res = await get(Uri.parse(endPointUrl));

    //first of all let's check that we got a 200 statu code: this mean that the request was a succes
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      //this line will allow us to get the different articles from the json file and putting them into a list
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }
}
