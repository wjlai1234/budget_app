import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:math' as math;

import '../dto/transaction.dart';
import '../isar_service.dart';

class TransactionDetails extends StatefulWidget {
  final IsarService service;
  final Transaction? transaction;
  final String type;

  const TransactionDetails(
      {Key? key, required this.service, this.transaction, required this.type})
      : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late TextEditingController _textController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  final DateRangePickerController _controller = DateRangePickerController();

  late String selectedValue; // Declare selectedValue here
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.transaction?.title);
    _categoryController =
        TextEditingController(text: widget.transaction?.categories);
    _amountController =
        TextEditingController(text: widget.transaction?.amount.toString());
// Update selectedValue based on widget.transaction?.categories
    selectedValue = widget.transaction?.categories ?? "Food & Beverage";

  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Food & Beverage", child: Text("Food & Beverage")),
      const DropdownMenuItem(value: "Fuel and Oil", child: Text("Fuel and Oil")),
      const DropdownMenuItem(value: "Entertainment", child: Text("Entertainment")),
      const DropdownMenuItem(value: "Subscription", child: Text("Subscription")),
      const DropdownMenuItem(value: "Tolls", child: Text("Tolls")),
    ];
    return menuItems;
  }


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
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
                          widget.type=='create'? const Text(
                            "Create your Transaction",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ):const Text(
                            "Update your Transaction",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          if (widget.type == "update")
                            GestureDetector(
                                onTap: () {
                                  widget.service
                                      .deleteTrans(widget.transaction!.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "New Transaction '${_textController.text}' successful deleted!",
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

                    //Title
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Transaction Title:",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5),
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
                                return "Account Name is not allowed to be empty";
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5),
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
                                return "Transaction Amount is not allowed to be empty";
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

                    //Datepicker
                    //Categories
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 5),
                      child: Text(
                        "Date:",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SfDateRangePicker(
                        controller: _controller,
                        backgroundColor: Colors.white,
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                        initialSelectedDate: widget.transaction?.dateTime,
                      ),
                    ),

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
                              widget.service.saveTransaction(Transaction()
                                ..id = widget.transaction!.id
                                ..title = _textController.text
                                ..categories = selectedValue
                                ..dateTime = _controller.selectedDate!
                                ..amount =
                                    double.parse(_amountController.text));
                            } else {
                              widget.service.saveTransaction(Transaction()
                                ..title = _textController.text
                                ..categories = selectedValue
                                ..dateTime = _controller.selectedDate!
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
                        child: widget.type=='create'? const Text(
                          "Add new Account",
                          style: TextStyle(fontSize: 18),
                        ):const Text(
                          "Update new Account",
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
      : assert(decimalRange > 0);

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
