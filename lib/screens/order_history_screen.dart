import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orderProvider.orders.isEmpty
          ? const Center(child: Text('No orders available'))
          : ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (ctx, i) {
                final order = orderProvider.orders[i];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ExpansionTile(
                    title: Text(
                      'Order ${i + 1}', // แสดงลำดับออเดอร์
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Time: ${order.id}', // ใช้ id เป็นเวลา (สมมติว่า id เป็นเวลาที่สร้างออเดอร์)
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    children: order.items.map((item) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${item.quantity}x',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
                        trailing: Text(
                          'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}