import 'package:budget_app/dto/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  late String iconName;
  late String title;
  late double amount;
  late double percentage;
  late bool status;

}