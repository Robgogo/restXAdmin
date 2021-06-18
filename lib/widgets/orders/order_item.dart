import 'package:flutter/material.dart';

import '../../services/orders_servce.dart';

class OrderItem extends StatelessWidget {
  final _orderService = OrderService();

  final String id;
  final String name;
  final int tableId;
  final bool accepted;
  final bool served;

  OrderItem({
    this.id,
    this.name,
    this.tableId,
    this.accepted,
    this.served,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('table: ${tableId.toString()}'),
      leading: CircleAvatar(
        child: Icon(Icons.food_bank),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            if (!accepted && !served)
              IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () {
                  _orderService.acceptOrder(id);
                },
                color: Theme.of(context).primaryColor,
              ),
            if (accepted && !served)
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  _orderService.serveOrder(id);
                },
              ),
            Text(!accepted && !served
                ? "Accept"
                : (accepted && !served)
                    ? "Serve"
                    : "Done"),
          ],
        ),
      ),
    );
  }
}
