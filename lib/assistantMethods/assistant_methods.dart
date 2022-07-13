import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList('userCart');
  tempList!.add(foodItemId! + ':$itemCounter');

  FirebaseFirestore.instance
      .collection('users')
      .doc(firebaseAuth.currentUser!.uid)
      .update({
    'userCart': tempList,
  }).then((value) {
    Fluttertoast.showToast(msg: 'Item Added Successfully.');

    sharedPreferences!.setStringList('userCart', tempList);

    // update the badge
  });
}
