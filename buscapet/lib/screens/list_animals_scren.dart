import 'package:buscapet/data/animals_data.dart';
import 'package:buscapet/tiles/pet_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListAnimalsScreen extends StatelessWidget {

  final DocumentSnapshot snapshot; // indica qual animal / categoria ele é
  ListAnimalsScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["title"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.list))
              ],
            ),
          ),

          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("pets").document(snapshot.documentID).collection("items").getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else {
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView.builder( // .builder carrega os items conforme a tela é abaixada
                      padding: const EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // quantidade de items na horizontal
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: snapshot.data.documents.length, 
                      itemBuilder: (context, index){

                        AnimalsData data = AnimalsData.fromDocument(snapshot.data.documents[index]);
                        data.animal = this.snapshot.documentID;

                        return PetTile("grid", data);
                      }
                    ),
                    
                    ListView.builder(
                      padding: const EdgeInsets.all(4.0),
                      itemCount: snapshot.data.documents.length, 
                      itemBuilder: (context, index){

                        AnimalsData data = AnimalsData.fromDocument(snapshot.data.documents[index]);
                        data.animal = this.snapshot.documentID;

                        return PetTile("list", data);
                      }
                    )
                  ],
                );
              }
            },
          )),
    );
  }
}
