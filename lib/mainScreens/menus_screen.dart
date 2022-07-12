import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../global/global.dart';

import '../models/menus.dart';
import '../models/sellers.dart';
import '../widgets/menus_design.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';
import '../widgets/sellers_design.dart';
import '../authentication/auth_screen.dart';
import '../widgets/text_widget.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;

  MenusScreen({this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          'iFood',
          style: TextStyle(
            fontSize: 45,
            fontFamily: 'Signatra',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
                title: widget.model!.sellerName.toString() + ' Menus'),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(widget.model!.sellerUID)
                  .collection('menus')
                  .orderBy(
                    'publishedDate',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          Menus model = Menus.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>,
                          );
                          return MenusDesignWidget(
                            model: model,
                            context: context,
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              }),
        ],
      ),
    );
  }
}
