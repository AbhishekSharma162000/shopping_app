import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/services/firebase_services.dart';
import 'package:shopping_app/widgets/custom_input.dart';
import 'package:shopping_app/widgets/product_card.dart';

class SearchTab extends StatefulWidget {

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children : [
          if(_searchString.isEmpty)
            Center(child: Container(child: Text("Serach Results",style: Constants.regularDarkText,)))
          else
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsRef.orderBy("search_string").
            startAt([_searchString])
                .endAt(["$_searchString\uf8ff"])
            .get(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.hasError}"),
                  ),
                );
              }

              // collection data ready to display
              if(snapshot.connectionState == ConnectionState.done){

                // Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(top: 128, bottom: 12),
                  children: snapshot.data.docs.map((document){
                    return ProductCard(
                      title: document['name'],
                      imageUrl: document['images'][0],
                      price: "\u{20B9}${document['price']}",
                      productId: document.id,
                    );
                  }).toList(),
                );
              }

              // loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: CustomInput(
              hintText: "Search here....",
              onSubmitted: (value){
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
              },
            ),
          ),
        ]
      ),
    );
  }
}
