import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../dto/goals.dart';
import '../isar_service.dart';

class GoalsDetails extends StatefulWidget {
  final IsarService service;
  final Goals? goals;
  final String type;

  const GoalsDetails(
      {Key? key, required this.service, this.goals, required this.type})
      : super(key: key);

  @override
  State<GoalsDetails> createState() => _GoalsDetailsState();
}

class _GoalsDetailsState extends State<GoalsDetails> {
  late TextEditingController _textController;
  late TextEditingController _amountController;
  late TextEditingController _percentageController;
  late TextEditingController _statusController;
  late String selectedValue;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.goals?.title);
    _amountController =
        TextEditingController(text: widget.goals?.amount.toString());
    _percentageController =
        TextEditingController(text: widget.goals?.percentage.toString());
    _statusController =
        TextEditingController(text: widget.goals?.status.toString());
    selectedValue = widget.goals?.status.toString() ?? "true";
  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    _percentageController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: 'true', child: Text("Pass")),
      const DropdownMenuItem(value: 'false', child: Text("Fail")),
    ];
    return menuItems;
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.type=='create'? const Text(
                            "Create your Goals",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ):const Text(
                            "Update your Goals",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          if (widget.type == "update")
                            GestureDetector(
                                onTap: () {
                                  widget.service.deleteGoals(widget.goals!.id);
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
                        "Goals Name:",
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
                                return "Goals Name is not allowed to be empty";
                              }
                              return null;
                            },
                          ),
                        )),


                    //Amount
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
                                return "Goals Amount is not allowed to be empty";
                              }
                              return null;
                            },
                          ),
                        )),

                    //Percentage
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Percentage:",
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
                            controller: _percentageController,
                            autofocus: true,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Goals Percentage is not allowed to be empty";
                              }
                              return null;
                            },
                          ),
                        )),

                    //Status
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Status:",
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
                              print("${_percentageController.text}aaaaa");
                              widget.service.saveGoals(Goals()
                                ..id = widget.goals!.id
                                ..title = _textController.text
                                ..iconName = _textController.text
                                ..percentage = double.parse(_percentageController.text)
                                ..status =  selectedValue == 'true' || selectedValue ==  'Pass' ? true : false
                                ..amount = double.parse(_amountController.text));
                            } else {
                              widget.service.saveGoals(Goals()
                                ..title = _textController.text
                                ..iconName = _textController.text
                                ..percentage = double.parse(_percentageController.text)
                                ..status = selectedValue == 'true' || selectedValue ==  'Pass' ? true : false
                                ..amount = double.parse(_amountController.text));
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "New Goals '${_textController.text}' successful modified!",
                                ),
                              ),
                            );

                            Navigator.pop(context, 'update');
                          }
                        },
                        child: widget.type=='create'?const Text(
                          "Add new Goals",
                          style: TextStyle(fontSize: 18),
                        ):const Text(
                          "Update new Goals",
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
