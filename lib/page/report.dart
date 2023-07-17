
import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/liabilities.dart';
import 'package:budget_app/dto/product.dart';
import 'package:budget_app/dto/transaction.dart';
import 'package:budget_app/page/product_details.dart';
import 'package:budget_app/page/transaction_details.dart';
import 'package:budget_app/page/wallet_details.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../dto/asset.dart';
import '../isar_service.dart';

class Report extends StatefulWidget {
  final IsarService service;

  const Report({Key? key, required this.service}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                StreamBuilder<List<Product>>(
                  stream: widget.service.listenToProducts(),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasData) {
                      final products = snapshot.data!;
                      double totalProductAmount = 0.0;
                      for (var product in products) {
                        totalProductAmount += product.amount;
                      }
                      return StreamBuilder<List<Asset>>(
                          stream: widget.service.listenToAssets(),
                          builder:
                              (context, AsyncSnapshot<List<Asset>> snapshot) {
                            if (snapshot.hasData) {
                              final assets = snapshot.data!;
                              double totalAssetAmount = 0.0;
                              for (var asset in assets) {
                                totalAssetAmount += asset.amount;
                              }
                              return StreamBuilder<List<Account>>(
                                  stream: widget.service.listenToAccount(),
                                  builder: (context,
                                      AsyncSnapshot<List<Account>> snapshot) {
                                    if (snapshot.hasData) {
                                      final accounts = snapshot.data!;
                                      double totalAccAmount = 0.0;
                                      for (var account in accounts) {
                                        totalAccAmount += account.amount;
                                      }

                                      double sum_up = totalAccAmount +
                                          totalProductAmount;
                                      return StreamBuilder<List<Liabilities>>(
                                          stream: widget.service
                                              .listenToLiabilities(),
                                          builder: (context,
                                              AsyncSnapshot<List<Liabilities>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              final liabilities =
                                                  snapshot.data!;
                                              double totalLibAmount = 0.0;
                                              for (var liability
                                                  in liabilities) {
                                                totalLibAmount +=
                                                    liability.amount;
                                              }

                                              return StreamBuilder<
                                                      List<Transaction>>(
                                                  stream: widget.service
                                                      .listenToTransaction(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              List<Transaction>>
                                                          snapshot) {
                                                    if (snapshot.hasData) {
                                                      final transactions =
                                                          snapshot.data!;
                                                      double totalTransAmount =
                                                          0.0;
                                                      for (var transaction
                                                          in transactions) {
                                                        totalTransAmount +=
                                                            transaction.amount;
                                                      }

                                                      double netProfit =
                                                          totalAccAmount +
                                                              totalProductAmount -
                                                              totalLibAmount
                                                              ;
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //Chart
                                                          if(!netProfit.isNaN)
                                                          Row(
                                                            children: <Widget>[
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      1.0,
                                                                  child:
                                                                      PieChart(
                                                                    PieChartData(
                                                                      pieTouchData:
                                                                          PieTouchData(
                                                                        touchCallback:
                                                                            (FlTouchEvent event,
                                                                                pieTouchResponse) {
                                                                          setState(
                                                                              () {
                                                                            if (!event.isInterestedForInteractions ||
                                                                                pieTouchResponse == null ||
                                                                                pieTouchResponse.touchedSection == null) {
                                                                              touchedIndex = -1;
                                                                              return;
                                                                            }
                                                                            touchedIndex =
                                                                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                                          });
                                                                        },
                                                                      ),
                                                                      borderData:
                                                                          FlBorderData(
                                                                        show:
                                                                            false,
                                                                      ),
                                                                      sectionsSpace:
                                                                          0,
                                                                      centerSpaceRadius:
                                                                          40,
                                                                      sections: showingSections(
                                                                          totalLibAmount,
                                                                          totalAccAmount,
                                                                          totalProductAmount),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 55.0,
                                                                    left: 15,
                                                                    right: 15),
                                                            child: Column(
                                                              children: [
                                                                const Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          'Sum Up',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        Tooltip(
                                                                          message:
                                                                              'The maximum 3 accounts limited',
                                                                          showDuration:
                                                                              Duration(seconds: 10),
                                                                          triggerMode:
                                                                              TooltipTriggerMode.tap,
                                                                          textStyle:
                                                                              TextStyle(color: Colors.white),
                                                                          child:
                                                                              Icon(
                                                                            Icons.info,
                                                                            size:
                                                                                25,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Divider(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    //Accounts
                                                                    ListTile(
                                                                      leading: const Icon(
                                                                          Icons
                                                                              .wallet,
                                                                          color:
                                                                              Colors.white),
                                                                      title:
                                                                          const Text(
                                                                        'Accounts',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          Text(
                                                                        'RM ${totalAccAmount.toStringAsFixed(2)}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.greenAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),


                                                                    //Assets
                                                                    ListTile(
                                                                      leading: const Icon(
                                                                          Icons
                                                                              .wallet,
                                                                          color:
                                                                              Colors.white),
                                                                      title:
                                                                          const Text(
                                                                        'Portfolio Profit',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          Text(
                                                                        'RM ${totalProductAmount.toStringAsFixed(2)}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.greenAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),

                                                                    //TOTAL
                                                                    ListTile(
                                                                      title:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 80.0),
                                                                        child:
                                                                            Text(
                                                                          'TOTAL :',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.blueGrey,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          Text(
                                                                        'RM ${sum_up.toStringAsFixed(2)}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.orangeAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),

                                                                    //Liabilities
                                                                    ListTile(
                                                                      leading: const Icon(
                                                                          Icons
                                                                              .wallet,
                                                                          color:
                                                                              Colors.white),
                                                                      title:
                                                                          const Text(
                                                                        'Liabilities',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          Text(
                                                                        'RM ${totalLibAmount.toStringAsFixed(2)}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.redAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),



                                                                    //TOTAL
                                                                    ListTile(
                                                                      title:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 50.0),
                                                                        child:
                                                                            Text(
                                                                          'Net TOTAL :',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.blueGrey,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          Text(
                                                                        'RM ${netProfit.toStringAsFixed(2)}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.orangeAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  });
                                            }
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          });
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      double totalLibAmount,
      double totalAccAmount,
      double totalProductAmount) {
    // Calculate category totals
    final categoryTotals = <String, double>{};

    categoryTotals['Profits'] = totalAccAmount+totalProductAmount;
    categoryTotals['Losses'] = totalLibAmount;
    double totalAmount =
        totalLibAmount +
        totalProductAmount +
        totalAccAmount
    ;

    return List.generate(categoryTotals.length, (i) {
      final category = categoryTotals.keys.elementAt(i);
      final amount = categoryTotals[category]!;
      double percentage = (amount / totalAmount) * 100;

      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: _getCategoryColor(
            category), // Define your own method to get colors based on category
        value: percentage,
        title: '${percentage.toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: Text(
          category,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}

Color _getCategoryColor(String category) {
  switch (category) {
    case 'Transactions':
      return Colors.blue;
    case 'Losses':
      return Colors.redAccent;
    case 'Profits':
      return Colors.greenAccent;
    case 'Accounts':
      return Colors.purple;
    case 'Assets':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String _getCategoryIcon(String category) {
  switch (category) {
    case 'Transactions':
      return 'assets/icons/etf.svg';
    case 'Liabilities':
      return 'assets/icons/crypto_currency.svg';
    case 'Portfolio Profit':
      return 'assets/icons/stock.svg';
    case 'Accounts':
      return 'assets/icons/forex-1.svg';
    case 'Assets':
      return 'assets/icons/forex-1.svg';
    default:
      return 'assets/icons/default-icon.svg';
  }
}

Color _getCategoryBorderColor(String category) {
  switch (category) {
    case 'Transactions':
      return Colors.purple;
    case 'Losses':
      return Colors.blueGrey;
    case 'Profits':
      return Colors.green;
    case 'Accounts':
      return Colors.yellow;
    case 'Assets':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
