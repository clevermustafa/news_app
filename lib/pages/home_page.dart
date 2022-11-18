import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newsapp/controller/news_provider.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false)
        .getNewsByCategory("business");
    super.initState();
  }

  String getCategoryByIndex(int index) {
    switch(index) {
      case 0:
        return "business";
        // break;
      case 1:
       return "entertainment";
        break;
      case 2:
        return"general";
        break;
      case 3:
        return"health";
        break;
      case 4:
        return"science";
        break;
      default:
        return "business";
      
    }
  }

  Widget _buildTabBar(String title) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xff6545DD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TabBar(
              onTap: (value) {
                final cat = getCategoryByIndex(value);
                Provider.of<NewsProvider>(context, listen: false)
        .getNewsByCategory(cat);
              },
              indicatorColor: Colors.transparent,
              isScrollable: true,
              tabs: [
                _buildTabBar("Business"),
                _buildTabBar("Entertainment"),
                _buildTabBar("General"),
                _buildTabBar("Health"),
                _buildTabBar("Science"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  TabBarBody(),
                  TabBarBody(),
                  TabBarBody(),
                  TabBarBody(),
                  TabBarBody(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TabBarBody extends StatelessWidget {
  const TabBarBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    return Stack(
      children: [
        newsProvider.newsModel == null
            ? const SizedBox()
            : ListView.builder(
                itemCount: newsProvider.newsModel!.articles!.length,
                itemBuilder: (context, index) {
                  log(newsProvider.newsModel.toString());
                  final Articles article =
                      newsProvider.newsModel!.articles![index];
                  return Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                     
                    ),
                    child: Column(children: [
                      Image.network(article.urlToImage ?? "https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg"),
                      Text(article.title ?? "No title")
                    ]),
                  );
                },
              ),
        Provider.of<NewsProvider>(context).isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox()
      ],
    );
  }
}
