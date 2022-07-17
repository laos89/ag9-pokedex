import 'pokedetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'pokemon.dart';
import 'package:ai10/pokemon.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Azazel17/pokehub/master/pokehub.json";

  POKEMON Pokehub = POKEMON(pokemon: []);

  @override
  void initState() {
    super.initState();
    _fetchData();
    print("Descargando");
  }

  _fetchData() async {
    var result = await http.get(Uri.parse(url));
    print(result.body);
    var decodeJson = json.decode(result.body);
    Pokehub = POKEMON.fromJson(decodeJson);
    print(Pokehub.toJson());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex 1"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Pokehub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: Pokehub.pokemon!
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pokedetails(
                                          pokemon: poke,
                                        )));
                          },
                          child: Hero(
                            tag: poke.img.toString(),
                            child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 95,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(poke.img.toString())),
                                    ),
                                  ),
                                  Text(
                                    poke.name.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
