import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'kennzeichen.dart';


void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),

    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/ferryman.jpg", fit: BoxFit.cover,),
          searchBarUI(),
        ],
      ),
    );
  }

  List<Kennzeichen> kennzeichenAll =[new Kennzeichen(short: 'Loading', long: 'Loading', display:ListTile(title: Text('Loading...'), subtitle: Text('Loading...'),) )];
  String search= '';

  Widget searchBarUI() {
    return FloatingSearchBar(
      hint: 'Search ...',
      openAxisAlignment: 0.0,
      axisAlignment: 0.0,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      onQueryChanged: (query){
        search = query;
      },
      onSubmitted: (query) {
        search = query;
      },
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          child: Material(
            color: Colors.white,
            child: Container(
              height: 400.0,
              color: Colors.white,
              child: kennzeichen()
            ),
          ),
        );
      },
    );
  }

  Widget kennzeichen() {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              searchList(search)
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> searchList(String searchString) {
    //print(kennzeichenAll[0].display);

    List<Kennzeichen> kennzeichenFiltered = kennzeichenAll.where((element) => element.short.startsWith(searchString.toUpperCase())).toList();

    List<Widget> kennzeichenDisplay = [];
      kennzeichenFiltered.forEach((element) => kennzeichenDisplay.add(element.display));
    return kennzeichenDisplay;
  }

  Future<void> createDefault(List listToAddTo) async {
    final String response = await rootBundle.loadString('assets/kennzeichen.json');
    final data = await json.decode(response);
    listToAddTo = [];
    for (var obj in data) {
      listToAddTo.add(new Kennzeichen(
          short: obj['short'],
          long: obj['long'],
          display: new ListTile(
            title: Text(obj['short']),
            subtitle: Text(obj['long']),
          )
      ));
    }
  }
}