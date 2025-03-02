import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';

class OrderApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Orders'),
      ),
      body: ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text('Order ${orderProvider.orders[i]['id']}'),
            subtitle: Text('Total: \$${orderProvider.orders[i]['amount']}'),
            trailing: IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                orderProvider.approveOrder(orderProvider.orders[i]['id']);
              },
            ),
          ),
        ),
      ),
    );
  }
}