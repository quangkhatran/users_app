import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import './cart_item_counter.dart';

separateItemIDs() {
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;
  defaultItemList = sharedPreferences!.getStringList('userCart')!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(':');
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    print('\nThis is itemID now =' + getItemId);
    separateItemIDsList.add(getItemId);
  }
  print('\nThis is Items List now =');
  print(separateItemIDsList);

  return separateItemIDsList;
}

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
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}
