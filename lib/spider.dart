import 'package:html/parser.dart' as html;
import 'package:http/http.dart';
import 'package:scrapy/scrapy.dart';

import 'model.dart';

class BlogSpider extends Spider<Quote, Quotes> {
  @override
  Stream<String> parse(Response response) async* {
    final document = html.parse(response.body);
//    final nodes = document.querySelectorAll("div.quote> span.text");
//    final nodes = document.querySelectorAll(".mw-category-group ul li > a");
//    final nodes = document.querySelectorAll(".wiki-paragraph .wiki-link-internal");
    final nodes = document.querySelectorAll(".wiki-heading-content ul li div > a.wiki-link-internal");

    for (var node in nodes) {
      yield node.innerHtml;
//      yield node.text;
    }
  }

  @override
  Stream<String> transform(Stream<String> stream) async* {
    await for (String parsed in stream) {
      final transformed = parsed;
      yield transformed;
//      yield transformed.substring(1, parsed.length - 1);
    }
  }

  @override
  Stream<Quote> save(Stream<String> stream) async* {
    await for (String transformed in stream) {
      final quote = Quote(quote: transformed);
      yield quote;
    }
  }
}
