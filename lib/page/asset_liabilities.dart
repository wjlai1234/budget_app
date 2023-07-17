import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/asset.dart';
import 'package:budget_app/dto/liabilities.dart';
import 'package:budget_app/dto/transaction.dart';
import 'package:budget_app/page/asset_details.dart';
import 'package:budget_app/page/liabilities_details.dart';
import 'package:budget_app/page/transaction_details.dart';
import 'package:budget_app/page/wallet_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../isar_service.dart';

class AssetNLiabilities extends StatefulWidget {
  final IsarService service;

  const AssetNLiabilities({Key? key, required this.service}) : super(key: key);

  @override
  State<AssetNLiabilities> createState() => _AssetNLiabilitiesState();
}

class _AssetNLiabilitiesState extends State<AssetNLiabilities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                StreamBuilder<List<Asset>>(
                  stream: widget.service.listenToAssets(),
                  builder: (context, AsyncSnapshot<List<Asset>> snapshot) {
                    if (snapshot.hasData) {
                      final assets = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var asset in assets) {
                        totalAmount += asset.amount;
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
                            'Total Assets',
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
                                          Row(
                                            children: const [
                                              Text(
                                                'My Assets',
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
                                                            AssetsDetails(
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
                                        itemCount: assets.length,
                                        itemBuilder: (context, index) {
                                          final asset = assets[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AssetsDetails(
                                                            service: widget.service,
                                                            asset: asset,
                                                            type: 'update',
                                                          )));
                                            },
                                            child: ListTile(
                                              leading: const Icon(Icons.web_asset,
                                                  color: Colors.white),
                                              title: Text(
                                                asset.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: Text(
                                                'RM ${asset.amount.toStringAsFixed(2)}',
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
                
                StreamBuilder<List<Liabilities>>(
                  stream: widget.service.listenToLiabilities(),
                  builder: (context, AsyncSnapshot<List<Liabilities>> snapshot) {
                    if (snapshot.hasData) {
                      final liabilities = snapshot.data!;
                      double totalAmount = 0.0;
                      for (var liability in liabilities) {
                        totalAmount += liability.amount;
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Liabilities',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
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
                                      style:  const TextStyle(
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
                                  itemCount: liabilities.length,
                                  itemBuilder: (context, index) {
                                    final liability = liabilities[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LiabilitiesDetails(
                                                      service: widget.service,
                                                  liabilities: liability,
                                                      type: 'update',
                                                    )));
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              liability.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              'RM ${liability.amount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          const Divider(color: Colors.grey,)
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
