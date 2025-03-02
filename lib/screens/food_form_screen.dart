import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../model/food_item.dart';
import '../provider/food_provider.dart';

class FoodFormScreen extends StatefulWidget {
  final FoodItem? food;

  const FoodFormScreen({super.key, this.food});

  @override
  _FoodFormScreenState createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late String _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _name = widget.food!.name;
      _description = widget.food!.description;
      _price = widget.food!.price;
      _imageUrl = widget.food!.imageUrl;
    } else {
      _name = '';
      _description = '';
      _price = 0.0;
      _imageUrl = '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final foodProvider = Provider.of<FoodProvider>(context, listen: false);
      if (widget.food != null) {
        foodProvider.updateFood(
          widget.food!.id,
          FoodItem(
            id: widget.food!.id,
            name: _name,
            description: _description,
            price: _price,
            imageUrl: _imageUrl,
          ),
        );
      } else {
        foodProvider.addFood(
          FoodItem(
            id: DateTime.now().toString(),
            name: _name,
            description: _description,
            price: _price,
            imageUrl: _imageUrl,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.food != null ? '🍽️ แก้ไขเมนูอาหาร' : '🍽️ เพิ่มเมนูอาหาร',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white, size: 28),
            tooltip: 'บันทึก',
            onPressed: _saveForm,
          ),
        ],
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  _buildTextFormField(
                    initialValue: _name,
                    labelText: 'ชื่อเมนู',
                    validatorMessage: 'กรุณากรอกชื่อเมนู',
                    onSaved: (value) => _name = value!,
                  ),
                  const SizedBox(height: 20),
                  // Description Field
                  _buildTextFormField(
                    initialValue: _description,
                    labelText: 'คำอธิบาย',
                    validatorMessage: 'กรุณากรอกคำอธิบาย',
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 20),
                  // Price Field
                  _buildTextFormField(
                    initialValue: _price.toString(),
                    labelText: 'ราคา (บาท)',
                    keyboardType: TextInputType.number,
                    validatorMessage: 'กรุณากรอกราคาที่ถูกต้อง',
                    numberValidator: true,
                    onSaved: (value) => _price = double.parse(value!),
                  ),
                  const SizedBox(height: 30),
                  // Image Preview
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              )
                            : _imageUrl.isNotEmpty
                                ? Image.file(
                                    File(_imageUrl),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildImagePlaceholder();
                                    },
                                  )
                                : _buildImagePlaceholder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Pick Image Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image, size: 24),
                      label: const Text(
                        'เลือกภาพ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String initialValue,
    required String labelText,
    required String validatorMessage,
    bool numberValidator = false,
    required void Function(String?) onSaved,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value!.isEmpty) {
            return validatorMessage;
          }
          if (numberValidator && double.tryParse(value) == null) {
            return 'กรุณากรอกตัวเลขที่ถูกต้อง';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.grey[200],
      child: const Icon(
        Icons.fastfood,
        size: 80,
        color: Colors.grey,
      ),
    );
  }
}