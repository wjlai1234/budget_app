import 'package:budget_app/dto/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

part 'account.g.dart';

@collection
class Account {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  late String iconName;
  late String title;
  late double amount;

  @Backlink(to: "account")
  final transaction = IsarLink<Transaction>();
}