import 'dart:math';

import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/product.dart';
import 'package:budget_app/page/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../isar_service.dart';

class ProductDetails extends StatefulWidget {
  final IsarService service;
  final Product? product;
  final String type;

  const ProductDetails(
      {Key? key, required this.service, this.product, required this.type})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late TextEditingController _textController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late String selectedValue;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.product?.title);
    _amountController =
        TextEditingController(text: widget.product?.amount.toString());
    _categoryController = TextEditingController(text: widget.product?.category);
    selectedValue = widget.product?.category ?? "Shares";
  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Shares", child: Text("Shares")),
      const DropdownMenuItem(value: "Forex", child: Text("Forex")),
      const DropdownMenuItem(value: "Indices", child: Text("Indices")),
      const DropdownMenuItem(value: "ETFs", child: Text("ETFs")),
      const DropdownMenuItem(value: "Cryptocurrency", child: Text("Cryptocurrency")),
      const DropdownMenuItem(value: "Bonds", child: Text("Bonds")),
      const DropdownMenuItem(value: "Funds", child: Text("Funds")),
      const DropdownMenuItem(value: "REITs", child: Text("REITs")),
      const DropdownMenuItem(value: "Indices Futures", child: Text("Indices Futures")),
      const DropdownMenuItem(value: "Commodities", child: Text("Commodities")),

    ];
    return menuItems;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.type == "create"
                              ? const Text(
                                  "Create your product",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  "Update your product",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                          if (widget.type == "update")
                            GestureDetector(
                                onTap: () {
                                  widget.service
                                      .deleteProduct(widget.product!.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "New financial product '${_textController.text}' successful deleted!",
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ))
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Product Name:",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextFormField(
                            controller: _textController,
                            autofocus: true,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return " Financial product Name is not allowed to be empty";
                              }
                              return null;
                            },
                          ),
                        )),
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Amount:",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextFormField(
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            controller: _amountController,
                            autofocus: true,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return " Financial product Amount is not allowed to be empty";
                              }
                              return null;
                            },
                          ),
                        )),

                    //Categories
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Category:",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    DropdownButtonFormField(
                        style: const TextStyle(color: Colors.white,fontSize: 18),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey,
                        ),
                        validator: (value) => value == null ? "Select a categories" : null,
                        dropdownColor: Colors.grey,

                        value: selectedValue,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: dropdownItems),

                    Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.type == 'update') {
                                widget.service.saveProduct(Product()
                                  ..id = widget.product!.id
                                  ..title = _textController.text
                                  ..iconName = _textController.text
                                  ..category =selectedValue
                                  ..amount =
                                      double.parse(_amountController.text));
                              } else {
                                widget.service.saveProduct(Product()
                                  ..title = _textController.text
                                  ..iconName = _textController.text
                                  ..category = selectedValue
                                  ..amount =
                                      double.parse(_amountController.text));
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "New Account '${_textController.text}' successful modified!",
                                  ),
                                ),
                              );

                              Navigator.pop(context, 'update');
                            }
                          },
                          child: widget.type == "create"
                              ? const Text(
                                  "Add new Product",
                                  style: TextStyle(fontSize: 18),
                                )
                              : const Text(
                                  "Update new Product",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
