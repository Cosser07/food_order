import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📜 ประวัติคำสั่งซื้อ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[50]!, Colors.orange[100]!],
          ),
        ),
        child: orderProvider.orders.isEmpty
            ? const Center(
                child: Text(
                  'ไม่มีคำสั่งซื้อที่ผ่านมา',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: orderProvider.orders.length,
                itemBuilder: (ctx, i) {
                  final order = orderProvider.orders[i];
                  print('Order ${i + 1} Items: ${order.items.map((item) => {
                    'id': item.id,
                    'name': item.name,
                    'quantity': item.quantity,
                    'price': item.price,
                    'imageUrl': item.imageUrl,
                  }).toList()}');
                  print('Order ${i + 1} Total Amount: ${order.totalAmount}');
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    shadowColor: Colors.orange.withOpacity(0.3),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.orange[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: 20,
                            child: Text(
                              '#${i + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            'คำสั่งซื้อที่ ${i + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.redAccent,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ยอดรวม: ${order.totalAmount.toStringAsFixed(2)} บาท',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'เวลา: ${order.id}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'ลบคำสั่งซื้อ',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('ยืนยันการลบ'),
                                  content: Text('คุณต้องการลบคำสั่งซื้อที่ ${i + 1} หรือไม่?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        orderProvider.deleteOrder(order.id);
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          children: order.items.isEmpty
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        'ไม่มีรายการในคำสั่งซื้อนี้',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              : [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Column(
                                      children: order.items.map((item) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.1),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: _buildImageFromUrl(item.imageUrl, context),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.name,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'ราคา: ${item.price.toStringAsFixed(2)} บาท | จำนวน: ${item.quantity}',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'รวม: ${(item.price * item.quantity).toStringAsFixed(2)} บาท',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                          collapsedBackgroundColor: Colors.white,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildImageFromUrl(String? imageUrl, BuildContext context) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // ตรวจสอบว่า imageUrl เป็น URL หรือไม่ (เริ่มด้วย http หรือ https)
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage(context);
          },
        );
      } else {
        // หากไม่ใช่ URL (เช่น พาธไฟล์ท้องถิ่น) ลองใช้ Image.file
        try {
          return Image.file(
            File(imageUrl),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderImage(context);
            },
          );
        } catch (e) {
          print('Error loading file image: $e');
          return _buildPlaceholderImage(context);
        }
      }
    } else {
      return _buildPlaceholderImage(context);
    }
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.fastfood,
        color: Colors.grey,
        size: 30,
      ),
    );
  }
}