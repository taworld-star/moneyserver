import 'package:flutter/material.dart';
import 'package:moneyserver/data/model/transaction.dart';
import 'package:moneyserver/data/repository/category_repository.dart';
import 'package:moneyserver/data/repository/transaction_repository.dart';
import 'package:moneyserver/data/service/httpservice.dart';
import 'package:moneyserver/data/usecase/response/GetCategoryResponse.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GetCategoryResponse? listCategory;
  final categoryRepo = CategoryRepository(HttpService());
  GetTransactionResponse? listTransaction;
  final tr = TransactionRepository(HttpService());

  @override
  void initState() {
    super.initState();
    loadCategory();
    loadtransaction();
  }

  Future<void> loadCategory() async {
    final response = await categoryRepo.getAllCategories();
    setState(() {
      listCategory = response;
    });
  }

   Future<void> loadtransaction() async {
    final response = await tr.getTransaction();
    setState(() {
      listTransaction = response;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Daftar Kategori"),
            Expanded(
              child: ListView.builder(
                itemCount: listCategory!.data.length,
                itemBuilder: (context, index) {
                return Text(listCategory!.data[index].name);
                },
              ),

            ),
            Expanded(
              child: ListView.builder(
                itemCount: listTransaction?.data.length ?? 0,
                itemBuilder: (context, index) {
                return ListTile(
                    leading: Text(listTransaction!.data[index].amount.toString()),
                    title: Text(listTransaction!.data[index].categoryName),
                );
              },
            ),
          ),
        ]
      ),
    )
  );
  }
}