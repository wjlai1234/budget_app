import 'package:budget_app/dto/account.dart';
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

import '../isar_service.dart';

class Portfolio extends StatefulWidget {
  final IsarService service;

  const Portfolio({Key? key, required this.service}) : super(key: key);

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
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
                      double totalAmount = 0.0;
                      for (var product in products) {
                        totalAmount += product.amount;
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
                            'Total profits',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),

                          if(totalAmount>0)
                          //Chart
                          AspectRatio(
                            aspectRatio: 1.3,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 0,
                                  sections: showingSections(products),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 55.0, left: 15, right: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Portfolio',
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
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        service: widget.service,
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
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    final percentage = (product.amount / totalAmount) * 100;

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                      service: widget.service,
                                                      product: product,
                                                      type: 'update',
                                                    )));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              product.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              'RM ${product.amount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                top: 1,
                                                bottom: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
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
                                                      product.category,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                 Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 12.0),
                                                  child: Text(
                                                    '${percentage.toStringAsFixed(2)}%',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
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

  List<PieChartSectionData> showingSections(List<Product> products) {
    // Calculate category totals
    final categoryTotals = <String, double>{};
    for (final product in products) {
      final category = product.category;
      categoryTotals.update(
        category,
        (value) => value + product.amount,
        ifAbsent: () => product.amount,
      );
    }

    // Calculate total amount
    final totalAmount =
        products.fold(0.0, (sum, product) => sum + product.amount);

    return List.generate(categoryTotals.length, (i) {
      final category = categoryTotals.keys.elementAt(i);
      final amount = categoryTotals[category]!;
      final percentage = (amount / totalAmount) * 100;

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
        badgeWidget: _Badge(
          _getCategoryIcon(
              category), // Define your own method to get icons based on category
          size: widgetSize,
          borderColor: _getCategoryBorderColor(
              category), // Define your own method to get border colors based on category
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
    case 'ETFs':
      return Colors.blue;
    case 'Cryptocurrency':
      return Colors.yellow;
    case 'Shares':
      return Colors.orange;
    case 'Forex':
      return Colors.purple;
    case 'Indices':
      return Colors.red;
    case 'Commodities':
      return Colors.green;
    case 'Bonds':
      return Colors.white;
    default:
      return Colors.grey;
  }
}

String _getCategoryIcon(String category) {
  switch (category) {
    case 'ETFs':
      return 'assets/icons/etf.svg';
    case 'Cryptocurrency':
      return 'assets/icons/crypto_currency.svg';
    case 'Shares':
      return 'assets/icons/stock.svg';
    case 'Forex':
      return 'assets/icons/forex-1.svg';
    case 'Indices':
      return 'assets/icons/index.svg';
    case 'Commodities':
      return 'assets/icons/commodities.svg';
    case 'Bonds':
      return 'assets/icons/bonds.svg';
    default:
      return 'assets/icons/forex-1.svg';
  }
}

Color _getCategoryBorderColor(String category) {
  switch (category) {
    case 'ETFs':
      return Colors.purple;
    case 'Cryptocurrency':
      return Colors.blueGrey;
    case 'Shares':
      return Colors.green;
    case 'Forex':
      return Colors.white;
    default:
      return Colors.grey;
  }
}
