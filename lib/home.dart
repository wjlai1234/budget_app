import 'package:budget_app/page/asset_liabilities.dart';
import 'package:budget_app/page/budget_income.dart';
import 'package:budget_app/page/dashboard.dart';
import 'package:budget_app/page/info.dart';
import 'package:budget_app/page/portfolio.dart';
import 'package:budget_app/page/report.dart';
import 'package:budget_app/page/transaction_details.dart';
import 'package:budget_app/page/wallet_details.dart';
import 'package:flutter/material.dart';

import 'isar_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late IsarService services;

  int currentTab = 0;
  late final List<Widget> screens;
  late Widget currentScreen;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    services = IsarService();
    screens = [Dashboard(service: services), AssetNLiabilities(service: services),Portfolio(service: services),BudgetIncome(service: services,)];
    currentScreen = Dashboard(service: services);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Info(service: services)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          color: Colors.grey[800],
          height: 65,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              //Dashboard
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Dashboard(
                      service: services,
                    );
                    currentTab = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard,
                      color: currentTab == 0 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        color: currentTab == 0 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              //Assets
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = AssetNLiabilities(
                      service: services,
                    );
                    currentTab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.web_asset_sharp,
                      color: currentTab == 1 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Assets',
                      style: TextStyle(
                        color: currentTab == 1 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              //Budget
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = BudgetIncome(
                      service: services,
                    );
                    currentTab = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_center,
                      color: currentTab == 3 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Budget',
                      style: TextStyle(
                        color: currentTab == 3 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              //Portfolio
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Portfolio(
                      service: services,
                    );
                    currentTab = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.candlestick_chart,
                      color: currentTab == 2 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Portfolio',
                      style: TextStyle(
                        color: currentTab == 2 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),

              //Report
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Report(
                      service: services,
                    );
                    currentTab = 4;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.document_scanner,
                      color: currentTab == 4 ? Colors.blue : Colors.grey,
                    ),
                    Text(
                      'Report',
                      style: TextStyle(
                        color: currentTab == 4 ? Colors.blue : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
