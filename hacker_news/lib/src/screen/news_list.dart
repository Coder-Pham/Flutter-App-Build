import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_tile.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    // This is a bad example, shouldnt try this
    bloc.fetchTopIds();
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top News',
          style: Theme.of(context).textTheme.headline,
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
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsTile(
                itemId: snapshot.data[index],
              );
            },
          );
      },
    );
  }
}
