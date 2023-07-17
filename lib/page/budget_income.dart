import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/asset.dart';
import 'package:budget_app/dto/budget.dart';
import 'package:budget_app/dto/liabilities.dart';
import 'package:budget_app/dto/transaction.dart';
import 'package:budget_app/page/asset_details.dart';
import 'package:budget_app/page/budget_details.dart';
import 'package:budget_app/page/goals_details.dart';
import 'package:budget_app/page/income_details.dart';
import 'package:budget_app/page/liabilities_details.dart';
import 'package:budget_app/page/transaction_details.dart';
import 'package:budget_app/page/wallet_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/goals.dart';
import '../dto/incomes.dart';
import '../isar_service.dart';

class BudgetIncome extends StatefulWidget {
  final IsarService service;

  const BudgetIncome({Key? key, required this.service}) : super(key: key);

  @override
  State<BudgetIncome> createState() => _BudgetIncomeState();
}

class _BudgetIncomeState extends State<BudgetIncome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                StreamBuilder<List<Incomes>>(
                  stream: widget.service.listenToIncome(),
                  builder: (context, AsyncSnapshot<List<Incomes>> snapshot) {
                    if (snapshot.hasData) {
                      final incomes = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var income in incomes) {
                        totalAmount += income.amount;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RM ${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Total Incomes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Card(
                                elevation: 2,
                                color: Colors.white24,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'Incomes',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Tooltip(
                                                message:
                                                    'A money/assets without using for saving purpose.',
                                                showDuration:
                                                    Duration(seconds: 10),
                                                triggerMode:
                                                    TooltipTriggerMode.tap,
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                child: Icon(
                                                  Icons.info,
                                                  size: 25,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IncomeDetails(
                                                              service: widget
                                                                  .service,
                                                              type: 'create')));
                                            },
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: incomes.length,
                                        itemBuilder: (context, index) {
                                          final income = incomes[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IncomeDetails(
                                                            service:
                                                                widget.service,
                                                            incomes: income,
                                                            type: 'update',
                                                          )));
                                            },
                                            child: ListTile(
                                              title: Text(
                                                income.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: Text(
                                                'RM ${income.amount.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                StreamBuilder<List<Budget>>(
                  stream: widget.service.listenToBudgets(),
                  builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                    if (snapshot.hasData) {
                      final budgets = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var budget in budgets) {
                        totalAmount += budget.amount;
                      }

                      return StreamBuilder<List<Incomes>>(
                          stream: widget.service.listenToIncome(),
                          builder:
                              (context, AsyncSnapshot<List<Incomes>> snapshot) {
                            if (snapshot.hasData) {
                              final incomes = snapshot.data!;
                              double totalIncomeAmount = 0.0;
                              for (var income in incomes) {
                                totalIncomeAmount += income.amount;
                              }
                              return StreamBuilder<List<Transaction>>(
                                  stream: widget.service.listenToTransaction(),
                                  builder: (context,
                                      AsyncSnapshot<List<Transaction>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      final transactions = snapshot.data!;
                                     
                                      
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: Card(
                                          elevation: 2,
                                          color: Colors.white24,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Row(
                                                      children: [
                                                        Text(
                                                          'Budgets',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'RM ${totalAmount.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.white,
                                                ),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: budgets.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    
                                                    
                                                    final budget =
                                                        budgets[index];

                                                    //Total Spend Category Amount
                                                    double totalTransactionsCateAmount = 0.0;
                                                    for (var transaction in transactions) {
                                                      if(transaction.categories == budget.title) {
                                                        totalTransactionsCateAmount += transaction.amount;
                                                      }
                                                    }

                                                    //Total Spend Category Amount
                                                    double budgetPercentage =
                                                        0.0;
                                                    double budgetAmount = 0.0;

                                                    if (budget.amount > 0) {

                                                      budgetAmount = budget
                                                              .amount /
                                                          totalIncomeAmount *
                                                          100;


                                                    } else {
                                                      budgetPercentage =
                                                          budget.percentage /
                                                              100 *
                                                              totalIncomeAmount;
                                                    }



                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BudgetDetails(
                                                                          service:
                                                                              widget.service,
                                                                          budget:
                                                                              budget,
                                                                          type:
                                                                              'update',
                                                                        )));
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          ListTile(
                                                            leading: budget
                                                                    .status
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green)
                                                                : const Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .redAccent),
                                                            title: Text(
                                                              budget.title,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            trailing:
                                                                budget.amount >
                                                                        0
                                                                    ? Text(
                                                                        'RM ${budget.amount.toStringAsFixed(2)}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        '${budget.percentage.toStringAsFixed(2)}%',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16.0),
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    child: Text(
                                                                     "Total: ${totalTransactionsCateAmount.toStringAsFixed(2)}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .white70,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16.0,
                                                                        top: 1,
                                                                        bottom:
                                                                            0),
                                                                child:
                                                                    budget.amount >
                                                                            0
                                                                        ? Text(
                                                                            '${budgetAmount.toStringAsFixed(2)}%',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white70,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            'RM${budgetPercentage.toStringAsFixed(2)}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white70,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                StreamBuilder<List<Goals>>(
                  stream: widget.service.listenToGoals(),
                  builder: (context, AsyncSnapshot<List<Goals>> snapshot) {
                    if (snapshot.hasData) {
                      final goals = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var goal in goals) {
                        totalAmount += goal.amount;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Card(
                          elevation: 2,
                          color: Colors.white24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Goals',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'RM ${totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.white,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: goals.length,
                                  itemBuilder: (context, index) {
                                    final goal = goals[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GoalsDetails(
                                                      service: widget.service,
                                                      goals: goal,
                                                      type: 'update',
                                                    )));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ListTile(
                                            leading: goal.status
                                                ? const Icon(Icons.check_circle,
                                                    color: Colors.green)
                                                : const Icon(Icons.cancel,
                                                    color: Colors.redAccent),
                                            title: Text(
                                              goal.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: goal.amount > 0
                                                ? Text(
                                                    'RM ${goal.amount.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Text(
                                                    '${goal.percentage.toStringAsFixed(2)}%',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
