import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/services/firebase_services.dart';
import 'package:shopping_app/widgets/custom_action_bar.dart';
import 'package:shopping_app/widgets/image_swipe.dart';
import 'package:shopping_app/widgets/product_size.dart';

class ProductPage extends StatefulWidget {

  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  FirebaseServices _firebaseServices = FirebaseServices();



  String _selectedProductSize = "0";

  Future _addToCart(){
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size" : _selectedProductSize});
  }

  Future _addToSaved(){
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size" : _selectedProductSize});
  }
  final SnackBar _snackBar = SnackBar(content: Text("Product added to the cart"),);
  final SnackBar _snackBar1 = SnackBar(content: Text("Product saved"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
         FutureBuilder(
           future: _firebaseServices.productsRef.doc(widget.productId).get(),
           builder: (context, snapshot){
             if(snapshot.hasError){
               return Scaffold(
                 body: Center(
                   child: Text("Error: ${snapshot.hasError}"),
                 ),
               );
             }

             if(snapshot.connectionState == ConnectionState.done){

               // Firebase Document Data Map
               Map<String, dynamic> documentData = snapshot.data.data();

               // List of images
               List imageList = documentData['images'];
               List productSizes = documentData['size'];

               // set an initial size
               _selectedProductSize = productSizes[0];

               return ListView(
                 children: [
                  ImageSwipe(imageList: imageList,),
                   Padding(
                     padding: const EdgeInsets.only(top:24, left:24, right: 24, bottom: 4),
                     child: Text("${documentData['name']}", style: Constants.boldHeading ,),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
                     child: Text("\$${documentData['price']}",
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w600,
                       color: Theme.of(context).accentColor
                     )
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                     child: Text("${documentData['desc']}", style: TextStyle(fontSize: 16),),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
                     child: Text("Select Size", style: Constants.regularDarkText,),
                   ),
                  ProductSize(
                    productSizes: productSizes,
                    onSelected: (size){
                      _selectedProductSize = size;
                    }
                  ),
                   Padding(
                     padding: const EdgeInsets.all(24.0),
                     child: Row(
                       children: [
                         GestureDetector(
                           onTap:() async{
                             await _addToSaved();
                             Scaffold.of(context).showSnackBar(_snackBar1);
                           },
                           child: Container(
                             width: 65,
                             height: 65,
                             decoration: BoxDecoration(
                               color: Color(0xFFDCDCDC),
                               borderRadius: BorderRadius.circular(12)
                             ),
                             child: Icon(Icons.bookmark_border_outlined, size: 39,)
                           ),
                         ),
                        Expanded(
                            child:  GestureDetector(
                              onTap:() async{
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                                },
                              child: Container(
                                margin: EdgeInsets.only(left: 16),
                                height: 65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text("Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ),
                                ),
                              ),
                            ),
                        )
                       ],
                     ),
                   )
                 ],
               );
             }

             return Scaffold(
               body: Center(
                 child: CircularProgressIndicator(),
               ),
             );
           },
         ),
          CustomActionBar(
            hasTitle: false,
            hasBackArrow: true,
            hasBackground: false,
          )
        ],
      )
    );
  }
}
