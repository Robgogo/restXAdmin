import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String name;
  final String orderedBy;
  final String tableId;
  final bool accepted;
  final bool served;

  OrderItem({
    this.name,
    this.orderedBy,
    this.tableId,
    this.accepted,
    this.served,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(orderedBy),
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
                onPressed: () {},
                color: Theme.of(context).primaryColor,
              ),
            if (accepted && !served)
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {},
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
