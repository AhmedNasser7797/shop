import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, price: 0.0, title: '', description: '', imageUrl: '');
  var _init = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isLoading = false;
//  void _saveForm() {
//    var validate = _form.currentState.validate();
//    if (!validate) {
//      return;
//    }
//    _form.currentState.save();
//    setState(() {
//      _isLoading = true;
//    });
//    // if the product have an id then i know i am editing
//    //if it doesn't have an id so i know i will add a new one
//    //because when i add a new one i set the id = null in the beggining
//    //and i set the id by DateTime.now()
//    if (_editedProduct.id != null) {
//      Provider.of<ProductsProvider>(context, listen: false)
//          .updateProduct(_editedProduct.id, _editedProduct);
//      setState(() {
//        _isLoading = false;
//      });
//      Navigator.of(context).pop();
//    } else {
//      Provider.of<ProductsProvider>(context, listen: false)
//          .addProduct(_editedProduct)
//          .catchError((error) {
//        return showDialog(
//          context: context,
//          builder: (ctx) => AlertDialog(
//              content: Text('something went wrong'),
//              title: Text('An error Occured!'),
//              actions: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(ctx).pop();
//                    },
//                    child: Text('okay'))
//              ]),
//        );
//      }).then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//        Navigator.of(context).pop();
//      });
//    }
//  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }

    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
       await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
//      finally {
//        setState(() {
//          _isLoading = false;
//        });
//        Navigator.of(context).pop();
//      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _init = false;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'this field is Required';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value,
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                            price: _editedProduct.price);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'].toString(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                            price: double.parse(value));
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter the price';
                        }
                        if (double.tryParse(value) == null)
                          return 'please enter a valid number';
                        if (double.parse(value) <= 0)
                          return 'please enter a number greater than zero';
                        else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
//                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            description: value,
                            price: _editedProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter the description';
                        }
                        if (value.length < 10)
                          return 'should be at least 10 characters';
                        else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a url')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image url',
                            ),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  imageUrl: value,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'p;ease enter an Image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'please enter a valid url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'please enter a valid url';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
