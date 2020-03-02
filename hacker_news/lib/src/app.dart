import 'package:flutter/material.dart';
import 'screen/news_list.dart';
import 'screen/news_detail.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'Hacker News',
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          // home: NewsList(),
          // ! Reference to function
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/')
      return MaterialPageRoute(
        builder: (context) {
          final bloc = StoriesProvider.of(context);
          bloc.fetchTopIds();

          return NewsList();
        },
      );
    else
      return MaterialPageRoute(
        builder: (context) {
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          final bloc = CommentsProvider.of(context);
          bloc.fetchComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        },
      );
  }
}
