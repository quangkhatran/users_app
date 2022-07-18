import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';

import '../models/address.dart';

import '../widgets/progress_bar.dart';
import '../widgets/status_banner.dart';
import '../widgets/shipment_address_design.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;

  OrderDetailsScreen({this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(sharedPreferences!.getString('uid'))
              .collection('orders')
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap['status'];
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap!['isSuccess'],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '£ ' + dataMap['totalAmount'].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Order Id = ' + widget.orderID!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Order at: ' +
                                DateFormat('dd MMMM, yyyy - hh:mm aa').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap['orderTime']))),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 4.0,
                        ),
                        orderStatus == 'ended'
                            ? Image.asset('images/delivered.jpg')
                            : Image.asset('images/state.jpg'),
                        const Divider(
                          thickness: 4.0,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(sharedPreferences!.getString('uid'))
                              .collection('userAddress')
                              .doc(dataMap['addressID'])
                              .get(),
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? ShipmentAddressDesign(
                                    model: Address.fromJson(snapshot.data!
                                        .data()! as Map<String, dynamic>),
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
