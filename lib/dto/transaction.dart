import 'package:budget_app/dto/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
 late String title;
  late String categories;
  late DateTime dateTime;
  late double amount;

  final account = IsarLink<Account>();
}