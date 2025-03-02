import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../model/food_item.dart';
import '../provider/food_provider.dart';
import 'dart:io';

class FoodFormScreen extends StatefulWidget {
  final FoodItem? food;

  FoodFormScreen({this.food});

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
        title: Text(widget.food != null ? 'Edit Food' : 'Add Food'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                SizedBox(height: 10),
                _imageFile != null
                    ? Image.file(_imageFile!, height: 150, width: 150, fit: BoxFit.cover)
                    : _imageUrl.isNotEmpty
                        ? Image.file(File(_imageUrl), height: 150, width: 150, fit: BoxFit.cover)
                        : Container(height: 150, width: 150, color: Colors.grey[200]),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Pick Image'),
                  onPressed: _pickImage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}