import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/asset.dart';
import 'package:budget_app/dto/liabilities.dart';
import 'package:budget_app/dto/transaction.dart';
import 'package:budget_app/page/asset_details.dart';
import 'package:budget_app/page/liabilities_details.dart';
import 'package:budget_app/page/transaction_details.dart';
import 'package:budget_app/page/wallet_details.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../isar_service.dart';

class TransactionsPages extends StatefulWidget {
  final IsarService service;

  const TransactionsPages({Key? key, required this.service}) : super(key: key);

  @override
  State<TransactionsPages> createState() => _TransactionsPagesState();
}

class _TransactionsPagesState extends State<TransactionsPages> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                StreamBuilder<List<Transaction>>(
                  stream: widget.service.listenToTransaction(),
                  builder:
                      (context, AsyncSnapshot<List<Transaction>> snapshot) {
                    if (snapshot.hasData) {
                      final transactions = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var transaction in transactions) {
                        totalAmount += transaction.amount;
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CalendarTimeline(
                              showYears: true,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 365 * 4)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                              onDateSelected: (date) => setState(() => _selectedDate = date),
                              leftMargin: 20,
                              monthColor: Colors.white70,
                              dayColor: Colors.teal[200],
                              dayNameColor: const Color(0xFF333A47),
                              activeDayColor: Colors.white,
                              activeBackgroundDayColor: Colors.redAccent[100],
                              dotsColor: const Color(0xFF333A47),
                              selectableDayPredicate: (date) => date.day != 23,
                              locale: 'en',
                            ),
                          ),
                          Padding(
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
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TransactionsPages(
                                                              service: widget
                                                                  .service,
                                                            )));
                                              },
                                              child: const Text(
                                                'Transactions',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'RM ${transactions
                                              .where((transaction) =>
                                          transaction.dateTime.year == _selectedDate.year &&
                                              transaction.dateTime.month == _selectedDate.month &&
                                              transaction.dateTime.day == _selectedDate.day)
                                              .map((transaction) => transaction.amount)
                                              .fold(0.0, (prev, amount) => prev + amount)
                                              .toStringAsFixed(2)}',
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: transactions.length,
                                      itemBuilder: (context, index) {
                                         var transaction = transactions[index];
                                         if (transaction.dateTime.day != _selectedDate.day ||
                                             transaction.dateTime.month != _selectedDate.month ||
                                             transaction.dateTime.year != _selectedDate.year) {
                                           // Skip transactions that don't match the selected date
                                           return Container(); // Empty container, won't be displayed
                                         }


                                         if (transaction.dateTime.year == _selectedDate.year &&
                                             transaction.dateTime.month == _selectedDate.month) {

                                           return GestureDetector(
                                             onTap: () {
                                               Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                       builder: (context) =>
                                                           TransactionDetails(
                                                             service:
                                                             widget.service,
                                                             transaction:
                                                             transaction,
                                                             type: 'update',
                                                           )));
                                             },
                                             child: Column(
                                               crossAxisAlignment:
                                               CrossAxisAlignment.end,
                                               children: [
                                                 ListTile(
                                                   title: Text(
                                                     transaction.title,
                                                     style: const TextStyle(
                                                       fontSize: 16,
                                                       color: Colors.white,
                                                       fontWeight: FontWeight.bold,
                                                     ),
                                                   ),
                                                   trailing: Text(
                                                     'RM ${transaction.amount.toStringAsFixed(2)}',
                                                     style: const TextStyle(
                                                       fontSize: 16,
                                                       color: Colors.white,
                                                       fontWeight: FontWeight.bold,
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
                                                       const EdgeInsets.only(
                                                           left: 16.0),
                                                       child: Container(
                                                         padding: const EdgeInsets
                                                             .symmetric(
                                                             horizontal: 8,
                                                             vertical: 4),
                                                         decoration: BoxDecoration(
                                                           borderRadius:
                                                           BorderRadius
                                                               .circular(20),
                                                           color: Colors.blue,
                                                         ),
                                                         child: ClipRRect(
                                                           borderRadius:
                                                           BorderRadius
                                                               .circular(16),
                                                           child: Text(
                                                             transaction
                                                                 .categories,
                                                             style:
                                                             const TextStyle(
                                                               fontSize: 14,
                                                               color:
                                                               Colors.white70,
                                                               fontWeight:
                                                               FontWeight.bold,
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                     Padding(
                                                       padding:
                                                       const EdgeInsets.only(
                                                           left: 20,
                                                           right: 16.0,
                                                           top: 1,
                                                           bottom: 0),
                                                       child: Text(
                                                         DateFormat('yyyy-MM-dd')
                                                             .format(transaction
                                                             .dateTime),
                                                         style: const TextStyle(
                                                           fontSize: 14,
                                                           color: Colors.white70,
                                                           fontWeight:
                                                           FontWeight.bold,
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
                                         }
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionDetails(
                                                          service:
                                                              widget.service,
                                                          transaction:
                                                              transaction,
                                                          type: 'update',
                                                        )));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  transaction.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  'RM ${transaction.amount.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
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
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.blue,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        child: Text(
                                                          transaction
                                                              .categories,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white70,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 16.0,
                                                            top: 1,
                                                            bottom: 0),
                                                    child: Text(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(transaction
                                                              .dateTime),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                          ),
                        ],
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
