import 'dart:math';

import 'package:budget_app/dto/account.dart';
import 'package:budget_app/page/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../dto/asset.dart';
import '../isar_service.dart';

class AssetsDetails extends StatefulWidget {
  final IsarService service;
  final Asset? asset;
  final String type;

  const AssetsDetails(
      {Key? key, required this.service, this.asset, required this.type})
      : super(key: key);

  @override
  State<AssetsDetails> createState() => _AssetsDetailsState();
}

class _AssetsDetailsState extends State<AssetsDetails> {
  late TextEditingController _textController;
  late TextEditingController _amountController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.asset?.title);
    _amountController =
        TextEditingController(text: widget.asset?.amount.toString());
  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        widget.type=='create'? const Text(
                          "Create your asset",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ):const Text(
                          "Update your asset",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        if (widget.type == "update")
                          GestureDetector(
                              onTap: () {
                                widget.service.deleteAsset(widget.asset!.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "New Account '${_textController.text}' successful deleted!",
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
                      "Asset Name:",
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
                              return "Asset Name is not allowed to be empty";
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
                          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: _amountController,
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Asset Amount is not allowed to be empty";
                            }
                            return null;
                          },
                        ),
                      )),
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
                            widget.service.saveAsset(Asset()
                              ..id = widget.asset!.id
                              ..title = _textController.text
                              ..iconName = _textController.text
                              ..amount = double.parse(_amountController.text));
                          } else {
                            widget.service.saveAsset(Asset()
                              ..title = _textController.text
                              ..iconName = _textController.text
                              ..amount = double.parse(_amountController.text));
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "New Asset '${_textController.text}' successful modified!",
                              ),
                            ),
                          );

                          Navigator.pop(context, 'update');
                        }
                      },
                      child: widget.type=='create'?const Text(
                        "Add new Asset",
                        style: TextStyle(fontSize: 18),
                      ):const Text(
                        "Update new Asset",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
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