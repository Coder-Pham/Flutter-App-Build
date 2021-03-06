import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top News',
          style: TextStyle(
            color: Colors.purpleAccent[400],
            fontSize: 24.0,
          ),
          // te Theme.of(context).textTheme.headline),
        ),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        else
          return Refresh(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                bloc.fetchItem(snapshot.data[index]);

                return NewsTile(
                  itemId: snapshot.data[index],
                );
              },
            ),
          );
      },
    );
  }
}
