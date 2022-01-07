import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/secret.dart';

enum NewsAction { Fetch, Delete }

class NewsBloc {
  final _stateStreamController = StreamController<List<Article>>();

  StreamSink<List<Article>> get newsSink => _stateStreamController.sink;
  Stream<List<Article>> get newsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();

  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get eventStream => _eventStreamController.stream;

  NewsBloc() {
    eventStream.listen((event) async {
      if (event == NewsAction.Fetch) {
        try {
          var news = await getArticle();
          newsSink.add(news.articles);
        } on Exception catch (e) {
          newsSink.addError('Something is Wrong');
        }
      }
    });
  }

  Future<NewsModel> getArticle() async {
    Response res = await get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey"));

    //checking if the request was a succes
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body);

      return NewsModel.fromJson(parsed);
    } else {
      throw ("Can't get the Articles");
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
