

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Category.dart';

class searchPage extends StatefulWidget {
  const searchPage({Key key}) : super(key: key);
  @override
  _searchPageState createState() => _searchPageState();

  }
  class _searchPageState extends State<searchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search Category'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                  context: context,
                  delegate: CategorySearch()
              );
            },
          )
        ],
      ),
    );
  }
  }
  class CategorySearch extends SearchDelegate{
  List<String> searchResult=[
    'Photographer',
    'MakeUp Artist',
    'Beauty Saloon',
    'Flower Shop',
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          if(query.isEmpty){
            close(context, null);
          }else {
            query = '';
          }
        },
       ),

    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
        onPressed: (){
        close(context, null);
        },

    );
  }

  @override
  Widget buildResults(BuildContext context)=> Center(
    child:InkWell(
       child: Text(
      'Photographer'
      ),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => Category(
            )));
      },
    ),


  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> Suggestions = searchResult.where((searchResult){
      final result= searchResult.toLowerCase();
      final intput= query.toLowerCase();
      return result.contains(intput);
    } ).toList();

    return ListView.builder(
        itemCount: Suggestions.length,
        itemBuilder: (context, index) {
          var Suggestion = Suggestions[index];
          return ListTile(
            title: Text(Suggestion),
            onTap: (){
              query= Suggestion;
              showResults(context);
            },
          );
        });
  }


  }
  


