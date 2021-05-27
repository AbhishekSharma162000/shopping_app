import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/custom_action_bar.dart';
import 'package:shopping_app/widgets/product_card.dart';

class HomeTab extends StatelessWidget {

  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
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
                  padding: EdgeInsets.only(top: 100, bottom: 12),
                  children: snapshot.data.docs.map((document){
                    return ProductCard(
                      title: document['name'],
                      imageUrl: document['images'][0],
                      price: "\$${document['price']}",
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
         CustomActionBar(
           hasBackArrow: false,
           title: "Home",
         )
        ],
      ),
    );
  }
}
