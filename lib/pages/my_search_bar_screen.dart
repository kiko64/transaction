import 'package:flutter/material.dart';

class MySearchBarScreen extends StatefulWidget {

  @override
  _MySearchBarScreenState createState() => _MySearchBarScreenState();
}

final soccerPlayers = ['Cristiano Ronaldo','Lionel Messi','Neymar Jr.','Kevin De Brune','Robert Lewandowski','Kylian Mbappe','Virgil van Dijk','Sadio Mane','Mohamed Salah'];

class _MySearchBarScreenState extends State<MySearchBarScreen> {

  int actual = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context, delegate: PlayerSearch(soccerPlayers));
            },
            icon: Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: Text('Search Bar Sample'),
      ),
      body: ListView.builder(
          itemCount: soccerPlayers.length,
          itemBuilder: (context, position) => ListTile(
            title: Text(soccerPlayers[position]),
            trailing: Icon(
              position == actual
                  ? Icons.check_circle
                  : Icons.panorama_fish_eye, // panorama_fish_eye, Icons.loop
              color: position == actual
                  ? Colors.teal
                  : null,
            ),
            onTap: () {
              setState(() {
                actual = position;
                print('novedad: ${actual}');

//                Navigator.pop(context); // Devolverme a la forma de transacción
              });
            }
          )),
    );
  }
}

class PlayerSearch extends SearchDelegate{

  List<String> listPlayers;
  late String selectedResult;
  PlayerSearch(this.listPlayers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestedSoccerPlayers = [];
    query.isEmpty ? suggestedSoccerPlayers = listPlayers
        : suggestedSoccerPlayers.addAll(listPlayers.where(
          (element) => element.toLowerCase().contains(query.toLowerCase()),
    ));

    return ListView.builder(
        itemCount: suggestedSoccerPlayers.length,
        itemBuilder: (context, position) => ListTile(
          title: Text(suggestedSoccerPlayers[position]),
        ));
  }

}