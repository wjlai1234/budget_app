import 'package:budget_app/dto/account.dart';
import 'package:budget_app/dto/asset.dart';
import 'package:budget_app/dto/budget.dart';
import 'package:budget_app/dto/goals.dart';
import 'package:budget_app/dto/incomes.dart';
import 'package:budget_app/dto/liabilities.dart';
import 'package:budget_app/dto/product.dart';
import 'package:budget_app/dto/transaction.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveAccount(Account newAccount) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.accounts.putSync(newAccount));
    print('save successful');
  }

  Future<void> saveTransaction(Transaction newTransaction) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.transactions.putSync(newTransaction));
    print(newTransaction.categories);
    print('save successful');
  }

  Future<void> saveAsset(Asset newAsset) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.assets.putSync(newAsset));
    print('save successful');
  }


  Future<void> saveLiabilities(Liabilities newLiabilities) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.liabilities.putSync(newLiabilities));
    print('save successful');
  }

  Future<void> saveProduct(Product newProduct) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.products.putSync(newProduct));
    print('save successful');
  }

  Future<void> saveBudget(Budget newBudget) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.budgets.putSync(newBudget));
    print('save successful');
  }

  Future<void> saveIncomes(Incomes newIncomes) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.incomes.putSync(newIncomes));
    print('save successful');
  }

  Future<void> saveGoals(Goals newGoals) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.goals.putSync(newGoals));
    print('save successful');
  }

  Future<List<Account>> getAllAccount() async {
    final isar = await db;
    return await isar.accounts.where().findAll();
  }

  Stream<List<Account>> listenToAccount() async* {
    final isar = await db;
    yield* isar.accounts.where().watch( fireImmediately: true);
  }

  Stream<List<Transaction>> listenToTransaction() async* {
    final isar = await db;
    yield* isar.transactions.where().watch( fireImmediately: true);
  }

  Stream<List<Asset>>? listenToAssets() async* {
    final isar = await db;
    yield* isar.assets.where().watch( fireImmediately: true);
  }

  Stream<List<Liabilities>>? listenToLiabilities() async* {
    final isar = await db;
    yield* isar.liabilities.where().watch( fireImmediately: true);
  }

  Stream<List<Product>>? listenToProducts() async* {
    final isar = await db;
    yield* isar.products.where().watch( fireImmediately: true);
  }

  Stream<List<Budget>>? listenToBudgets() async* {
    final isar = await db;
    yield* isar.budgets.where().watch( fireImmediately: true);
  }
  Stream<List<Incomes>>? listenToIncome() async* {
    final isar = await db;
    yield* isar.incomes.where().watch( fireImmediately: true);
  }
  Stream<List<Goals>>? listenToGoals() async* {
    final isar = await db;
    yield* isar.goals.where().watch( fireImmediately: true);
  }

  Future<void> deleteAcc(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.accounts.delete(id));
  }
  Future<void> deleteTrans(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.transactions.delete(id));
  }
  Future<void> deleteAsset(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.assets.delete(id));
  }
  Future<void> deleteLiabilities(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.liabilities.delete(id));
  }
  Future<void> deleteProduct(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.products.delete(id));
  }
  Future<void> deleteBudget(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.budgets.delete(id));
  }
  Future<void> deleteIncome(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.incomes.delete(id));
  }
  Future<void> deleteGoals(int id) async {
    final isar = await db;
    await isar.writeTxn(() =>  isar.goals.delete(id));
  }
  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<List<Transaction>> getTransactionFor(Account account) async {
    final isar = await db;
    return await isar.transactions
        .filter()
        .account((q) => q.idEqualTo(account.id))
        .findAll();
  }


  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [AccountSchema, TransactionSchema, AssetSchema,LiabilitiesSchema,ProductSchema, BudgetSchema,IncomesSchema,GoalsSchema],
        inspector: true, directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
