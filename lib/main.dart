import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kpop/model.dart';
import 'package:kpop/spider.dart';
import 'package:kpop/storage.dart';

void main() async {
  final spider = BlogSpider();
  spider.name = "myspider";
  final storage = QuoteStorage();
  final path = await storage.localPath;
  spider.path = "$path/data.json";
  spider.client = Client();
//  spider.startUrls = ["http://quotes.toscrape.com/page/7/", "http://quotes.toscrape.com/page/8/", "http://quotes.toscrape.com/page/9/"];
//  spider.startUrls = ["https://ko.wikipedia.org/wiki/%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD%EC%9D%98_%EC%95%84%EC%9D%B4%EB%8F%8C_%EA%B7%B8%EB%A3%B9_%EB%AA%A9%EB%A1%9D#%EA%B0%99%EC%9D%B4_%EB%B3%B4%EA%B8%B0"];
//  spider.startUrls = ["https://ko.wikipedia.org/wiki/%EB%B6%84%EB%A5%98:%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD%EC%9D%98_%EC%95%84%EC%9D%B4%EB%8F%8C_%EA%B7%B8%EB%A3%B9"];
  spider.startUrls = ["https://namu.wiki/w/%EB%B3%B4%EC%9D%B4%EA%B7%B8%EB%A3%B9/%EB%AA%A9%EB%A1%9D",'https://namu.wiki/w/%EA%B1%B8%EA%B7%B8%EB%A3%B9/%EB%AA%A9%EB%A1%9D'];
//  spider.startUrls = ["https://namu.wiki/w/%EB%B3%B4%EC%9D%B4%EA%B7%B8%EB%A3%B9/%EB%AA%A9%EB%A1%9D"];
//
  final stopw = Stopwatch()..start();

  await spider.startRequests();
  await spider.saveResult();
  final elapsed = stopw.elapsed;

  print("the program took $elapsed");

  print(await storage.getQuotes());

  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: storage),
    ),
  );
}

class FlutterDemo extends StatefulWidget {
  final QuoteStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: const Text('Scrapy on flutter')),
//      body: Center(
//        child: FutureBuilder(
//            future: storage.getQuotes(),
//            builder: (context, AsyncSnapshot<Quotes> snapshot) {
//              return snapshot.hasData
//                  ? ListView.builder(
//                itemCount: 10,
//                itemBuilder: (context, index) {
//                  final quotes = snapshot.data;
//                  return Card(
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(quotes.items[index].quote),
//                      ));
//                },
//              )
//                  : const CircularProgressIndicator();
//            }),
//      ),
//    );
//  }

  @override
  _MyHomePageState createState() => _MyHomePageState(this.storage);
}

class _MyHomePageState extends State<FlutterDemo> {
  final QuoteStorage storage;
  _MyHomePageState(this.storage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scrapy on flutter')),
      body: Center(
        child: FutureBuilder(
            future: storage.getQuotes(),
            builder: (context, AsyncSnapshot<Quotes> snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.items.length,
                      itemBuilder: (context, index) {
                        final quotes = snapshot.data;
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(quotes.items[index].quote),
                        ));
                      },
                    )
                  : const CircularProgressIndicator();
            }),
      ),
    );
  }
}
