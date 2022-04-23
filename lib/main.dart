import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parcial3_2552952017/modelos/Bebidas.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

void main() {
  runApp(Parcial3());
}

class Parcial3 extends StatefulWidget {
  @override
  State<Parcial3> createState() => _Parcial3State();
}

class _Parcial3State extends State<Parcial3> {
  late Future<List<Bebidas>> _listadoBebida;

  Future<List<Bebidas>> _getBebidas() async {
    final response = await http.get(Uri.parse(
        "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a"));
    String cuerpo;
    List<Bebidas> lista = [];

    if (response.statusCode == 200) {
      print(response.body);
      cuerpo = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(cuerpo);
      for (var item in jsonData["drinks"]) {
        lista.add(Bebidas(item["strDrink"], item["strDrinkThumb"],
            item["strCategory"], item["strInstructions"]));
      }
    } else {
      throw Exception("Falla en conexion  estado 500");
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();
    _listadoBebida = _getBebidas();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoBebida,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listadoBebidas(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parcial 3 - API Bebidas',
      home: Scaffold(
          appBar: AppBar(
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color.fromARGB(148, 202, 138, 0),
            title: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Parcial 3 - Bebidas API"),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    child: Icon(
                      Entypo.drink,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: futureBuilder),
    );
  }

  List<Widget> _listadoBebidas(data) {
    List<Widget> bebidaslist = [];

    for (var itembeb in data) {
      bebidaslist.add(Card(
        elevation: 0.5,
        child: Column(//mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          Row(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  width: 230,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              itembeb.strDrink,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Categoría: " + itembeb.strCategory,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Color.fromARGB(147, 145, 100, 5),
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Instructions: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                itembeb.strInstructions,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                    fontFamily: 'Roboto'),
                              )),
                        ]),
                  )),
              Container(
                width: 100,
                padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(itembeb.strDrinkThumb),
                          scale: 0.05),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ]),
      ));
    }
    return bebidaslist;
  }
}
