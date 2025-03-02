import 'dart:io';

import 'package:account/model/food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🛒 ตะกร้าสินค้า',
          style: const TextStyle(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // รายการสินค้าในตะกร้า (ด้านบน)
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'ไม่มีสินค้าในตะกร้า',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: cartItems.length,
                        itemBuilder: (ctx, i) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          shadowColor: Colors.orange.withOpacity(0.2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: cartItems[i].imageUrl.isNotEmpty
                                        ? _buildImageFromUrl(cartItems[i].imageUrl, context)
                                        : _buildPlaceholderImage(context),
                                  ),
                                  const SizedBox(width: 10),
                                  CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius: 18,
                                    child: Text(
                                      '${cartItems[i].quantity}x',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                cartItems[i].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                'ราคา: ฿${cartItems[i].price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: Text(
                                'รวม: ฿${(cartItems[i].price * cartItems[i].quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              // ส่วน "ยอดรวม" และ "สั่งซื้อเลย" ด้านล่าง (สวยงามและทันสมัย)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ไอคอนและข้อความ "ยอดรวม"
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${cartProvider.totalAmount.toStringAsFixed(2)} บาท',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    // ไอคอน "สั่งซื้อเลย" (แทนข้อความ)
                    IconButton(
                      icon: Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: cartItems.isEmpty
                          ? null
                          : () {
                              // ตรวจสอบและพิมพ์ข้อมูลก่อนส่ง
                              print('Cart Items before ordering: $cartItems');
                              if (cartItems.isNotEmpty) {
                                orderProvider.addOrder(cartItems);
                                cartProvider.clear();
                              } else {
                                print('Error: Cart is empty, cannot place order.');
                              }
                            },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ),
                      tooltip: 'สั่งซื้อเลย',
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          width: 50,
          height: 50,
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
            width: 50,
            height: 50,
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
      width: 50,
      height: 50,
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