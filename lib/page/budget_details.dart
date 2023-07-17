import 'dart:math';

import 'package:budget_app/dto/account.dart';
import 'package:budget_app/page/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../dto/asset.dart';
import '../dto/budget.dart';
import '../dto/incomes.dart';
import '../dto/transaction.dart';
import '../isar_service.dart';

class BudgetDetails extends StatefulWidget {
  final IsarService service;
  final Budget? budget;
  final String type;

  const BudgetDetails(
      {Key? key, required this.service, this.budget, required this.type})
      : super(key: key);

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  late TextEditingController _textController;
  late TextEditingController _amountController;
  late TextEditingController _percentageController;
  late TextEditingController _statusController;
  late String selectedValue;
  late String selectedCateValue;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.budget?.title);
    _amountController =
        TextEditingController(text: widget.budget?.amount.toString()??"0.0");
    _percentageController =
        TextEditingController(text: widget.budget?.percentage.toString()??"0");
    // _statusController =
    //     TextEditingController(text: widget.budget?.status.toString());
    selectedValue = widget.budget?.status.toString() ?? "Pass";
    selectedCateValue = widget.budget?.title.toString() ?? "Food & Beverage";
  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    _percentageController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get dropdownCateItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Food & Beverage", child: Text("Food & Beverage")),
      const DropdownMenuItem(
          value: "Fuel and Oil", child: Text("Fuel and Oil")),
      const DropdownMenuItem(
          value: "Entertainment", child: Text("Entertainment")),
      const DropdownMenuItem(
          value: "Subscription", child: Text("Subscription")),
      const DropdownMenuItem(
          value: "Toll", child: Text("Toll")),
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
                          widget.type == 'create'
                              ? const Text(
                                  "Create your Budget",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  "Update your Budget",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                          if (widget.type == "update")
                            GestureDetector(
                                onTap: () {
                                  widget.service
                                      .deleteBudget(widget.budget!.id);
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
                        "Budget Name:",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    DropdownButtonFormField(
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey,
                        ),
                        validator: (value) =>
                            value == null ? "Select a categories" : null,
                        dropdownColor: Colors.grey,
                        value: selectedCateValue,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedCateValue = newValue!;
                          });
                        },
                        items: dropdownCateItems),




                    StreamBuilder<List<Transaction>>(
                        stream: widget.service.listenToTransaction(),
                        builder: (context,
                            AsyncSnapshot<List<Transaction>> snapshot) {
                          if (snapshot.hasData) {
                            final transactions = snapshot.data!;
                            //Total Spend Category Amount
                            double totalTransactionsCateAmount = 0.0;
                            for (var transaction in transactions) {
                              if (transaction.categories == selectedCateValue) {
                                totalTransactionsCateAmount +=
                                    transaction.amount;
                              }
                            }

                            return StreamBuilder<List<Incomes>>(
                                stream: widget.service.listenToIncome(),
                                builder: (context,
                                    AsyncSnapshot<List<Incomes>> snapshot) {

                                  if (snapshot.hasData) {
                                    final incomes = snapshot.data!;
                                    double totalIncomeAmount = 0.0;
                                    for (var income in incomes) {
                                      totalIncomeAmount += income.amount;
                                    }
                                    if (double.parse(_amountController.text) >
                                        0) {
                                      if (double.parse(_amountController.text) <
                                          totalTransactionsCateAmount) {
                                        selectedValue = "Fail";
                                      } else {
                                        selectedValue = "Pass";
                                      }
                                    } else {
                                      if ((double.parse(
                                                  _percentageController.text) /
                                              100 *
                                              totalIncomeAmount) <
                                          totalTransactionsCateAmount) {
                                        selectedValue = "Fail";
                                      } else {
                                        selectedValue = "Pass";
                                      }
                                    }
                                    _statusController =
                                         TextEditingController(text: selectedValue.toString());
                                   double percentToValue = double.parse(
                                        _percentageController.text) /
                                        100 *
                                        totalIncomeAmount;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

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
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (double.parse(_amountController.text) >
                                                        0) {
                                                      if (double.parse(_amountController.text) <
                                                          totalTransactionsCateAmount) {
                                                        _statusController.text  = "Fail";
                                                      } else {
                                                        _statusController.text = "Pass";
                                                      }
                                                    } else {
                                                      if ((double.parse(
                                                          _percentageController.text) /
                                                          100 *
                                                          totalIncomeAmount) <
                                                          totalTransactionsCateAmount) {
                                                        _statusController.text = "Fail";
                                                      } else {
                                                        _statusController.text = "Pass";
                                                      }
                                                    }
                                                  });
                                                },
                                                inputFormatters: [
                                                  DecimalTextInputFormatter(decimalRange: 2)
                                                ],
                                                keyboardType: const TextInputType.numberWithOptions(
                                                    decimal: true),
                                                controller: _amountController,
                                                autofocus: true,
                                                style: const TextStyle(
                                                    fontSize: 18, color: Colors.white),
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Budget Amount is not allowed to be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),

                                        //Percentage
                                         Padding(
                                          padding: const EdgeInsets.only(top: 35, bottom: 5),
                                          child: Text(
                                            "Percentage: RM${percentToValue.toStringAsFixed(2)}",
                                            style: const TextStyle(fontSize: 18, color: Colors.grey),
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
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (double.parse(_amountController.text) >
                                                        0) {
                                                      if (double.parse(_amountController.text) <
                                                          totalTransactionsCateAmount) {
                                                        _statusController.text  = "Fail";
                                                      } else {
                                                        _statusController.text = "Pass";
                                                      }
                                                    } else {
                                                      if ((double.parse(
                                                          _percentageController.text) /
                                                          100 *
                                                          totalIncomeAmount) <
                                                          totalTransactionsCateAmount) {
                                                        _statusController.text = "Fail";
                                                      } else {
                                                        _statusController.text = "Pass";
                                                      }
                                                    }
                                                  });
                                                },

                                                inputFormatters: [
                                                  DecimalTextInputFormatter(decimalRange: 2)
                                                ],
                                                keyboardType: const TextInputType.numberWithOptions(
                                                    decimal: true),
                                                controller: _percentageController,
                                                autofocus: true,
                                                style: const TextStyle(
                                                    fontSize: 18, color: Colors.white),
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Budget Percentage is not allowed to be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),

                                        //Status
                                         Padding(
                                          padding: const EdgeInsets.only(top: 35, bottom: 5),
                                          child: Text(
                                            "Status: RM${totalTransactionsCateAmount.toStringAsFixed(2)}",
                                            style: const TextStyle(fontSize: 18, color: Colors.grey),
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

                                                keyboardType: const TextInputType.numberWithOptions(
                                                    decimal: true),
                                                controller: _statusController,
                                                autofocus: true,
                                                style: const TextStyle(
                                                    fontSize: 18, color: Colors.white),
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Budget Percentage is not allowed to be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),

                                      ],
                                    );
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                });
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        }),

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
                              widget.service.saveBudget(Budget()
                                ..id = widget.budget!.id
                                ..title = selectedCateValue
                                ..iconName = _textController.text
                                ..percentage =
                                    double.parse(_percentageController.text)
                                ..status = selectedValue == 'true' ||
                                        selectedValue == 'Pass'
                                    ? true
                                    : false
                                ..amount =
                                    double.parse(_amountController.text));
                            } else {
                              widget.service.saveBudget(Budget()
                                ..title = selectedCateValue
                                ..iconName = _textController.text
                                ..percentage =
                                    double.parse(_percentageController.text)
                                ..status = selectedValue == 'true' ||
                                        selectedValue == 'Pass'
                                    ? true
                                    : false
                                ..amount =
                                    double.parse(_amountController.text));
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "New Budget '${_textController.text}' successful modified!",
                                ),
                              ),
                            );

                            Navigator.pop(context, 'update');
                          }
                        },
                        child: widget.type == 'create'
                            ? const Text(
                                "Add new Budget",
                                style: TextStyle(fontSize: 18),
                              )
                            : const Text(
                                "Update new Budget",
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
