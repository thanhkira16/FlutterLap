import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'e4c1f98806354e80b57b6164c9d0f071';

  Future<List<Article>> getTopHeadlines() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<List<Article>> searchNews(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to search news');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }
}
