import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/transaction.dart';
import 'package:budget_app/page/transaction.dart';
import 'package:budget_app/page/transaction_details.dart';
import 'package:budget_app/page/wallet_details.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../isar_service.dart';

class Dashboard extends StatefulWidget {
  final IsarService service;

  const Dashboard({Key? key, required this.service}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                StreamBuilder<List<Account>>(
                  stream: widget.service.listenToAccount(),
                  builder: (context, AsyncSnapshot<List<Account>> snapshot) {
                    if (snapshot.hasData) {
                      final accounts = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var account in accounts) {
                        totalAmount += account.amount;
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
                            'Total balances',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),



                          Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(top: 25),
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              height: accounts.length == 2
                                  ? MediaQuery.of(context).size.height * 0.23
                                  : MediaQuery.of(context).size.height * 0.3005,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            'My Wallets',
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
                                                'The maximum 3 accounts limited',
                                            showDuration: Duration(seconds: 10),
                                            triggerMode: TooltipTriggerMode.tap,
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            child: Icon(
                                              Icons.info,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (accounts.length <= 2)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WalletDetails(
                                                            service:
                                                                widget.service,
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
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: accounts.length,
                                    itemBuilder: (context, index) {
                                      final account = accounts[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WalletDetails(
                                                        service: widget.service,
                                                        account: account,
                                                        type: 'update',
                                                      )));
                                        },
                                        child: ListTile(
                                          leading: const Icon(Icons.wallet,
                                              color: Colors.white),
                                          title: Text(
                                            account.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: Text(
                                            'RM ${account.amount.toStringAsFixed(2)}',
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
                              )),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
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
                                      children: [
                                        GestureDetector(
                                          onTap:(){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionsPages(
                                                          service: widget.service,
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
                                        SizedBox(
                                          width: 3,
                                        ),
                                        // Tooltip(
                                        //   message: 'The maximum 3 accounts limited',
                                        //   showDuration: Duration(seconds: 10),
                                        //   triggerMode: TooltipTriggerMode.tap,
                                        //   textStyle: TextStyle(color: Colors.white),
                                        //   child: Icon(
                                        //     Icons.info,
                                        //     size: 25,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Text(
                                      'RM ${totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
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
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionDetails(
                                                      service: widget.service,
                                                      transaction: transaction,
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
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20),
                                                    color: Colors.blue,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        16),
                                                    child: Text(
                                                      transaction.categories,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                    right: 16.0,
                                                    top: 1,
                                                    bottom: 0),
                                                child: Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(transaction.dateTime),
                                                  style: const TextStyle(
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

