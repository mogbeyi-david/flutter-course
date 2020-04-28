import 'package:flutter/material.dart';
import '../widgets/helpers/ensure_visible.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/scoped-models/main.dart';

import 'package:flutter_course/models/product.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    "title": null,
    "description": null,
    "price": null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = new FocusNode();
  final _descriptionFocusNode = new FocusNode();
  final _priceFocusNode = new FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      child: TextFormField(
        focusNode: _titleFocusNode,
        initialValue: product != null ? product.title : "",
        decoration: InputDecoration(labelText: 'Product Title'),
        // ignore: missing_return
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return "Title is required and should be 5 plus characters long";
          }
        },
        onSaved: (String value) {
          _formData["title"] = value;
        },
      ),
      focusNode: _titleFocusNode,
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
          focusNode: _descriptionFocusNode,
          initialValue: product != null ? product.description : "",
          maxLines: 4,
          // ignore: missing_return
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return "Description is required and should be 10 plus characters long";
            }
          },
          onSaved: (String value) {
            _formData["description"] = value;
          },
          decoration: InputDecoration(labelText: 'Product Description')),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
          focusNode: _priceFocusNode,
          initialValue: product != null ? product.price.toString() : "",
          keyboardType: TextInputType.number,
          // ignore: missing_return,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
              return "Price is required and should be a number";
            }
          },
          onSaved: (String value) {
            _formData["price"] = double.parse(value);
          },
          decoration: InputDecoration(labelText: 'Product Price')),
    );
  }

  void _submitForm(Function addProduct, Function updateProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == null) {
      addProduct(
        _formData["title"],
        _formData["description"],
        _formData["image"],
        _formData["price"],
      );
    } else {
      updateProduct(_formData["title"], _formData["description"],
          _formData["image"], _formData["price"]);
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct,
              model.selectedProductIndex),
        );
      },
    );
  }

  Widget buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              buildSubmitButton()
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(title: Text("Edit Product")),
                body: pageContent,
              );
      },
    );
  }
}
