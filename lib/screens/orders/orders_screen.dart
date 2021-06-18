import 'package:flutter/material.dart';

import '../../widgets/orders/order_item.dart';
import '../../services/orders_servce.dart';

class OrdersScreen extends StatelessWidget {
  final _orderService = OrderService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _orderService.streamobject,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.docs;
        print(documents.length);
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (ctx, i) => Column(
            children: [
              OrderItem(
                id: documents[i].id,
                name: documents[i].data()['name'],
                tableId: documents[i].data()['table'],
                accepted: documents[i].data()['accepted'],
                served: documents[i].data()['served'],
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
