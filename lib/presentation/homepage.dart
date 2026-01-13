import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moneyserver/data/model/transaction.dart';
import 'package:moneyserver/data/repository/transaction_repository.dart';
import 'package:moneyserver/data/service/httpservice.dart';
import 'package:moneyserver/presentation/insert.page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double _balance =0;
  String _income = '0';
  double _expense =0;
  final _transactionRepo = TransactionRepository(HttpService());
  List<Transaction> _transactions = [];

  @override
  void initState(){
    super.initState();
    _loadData();
    _loadIncome();
  }

  Future<void> _loadData() async {
    try{
      final response = await _transactionRepo.getTransaction();
      if (response.status == 'success'){
        setState(() {
          _transactions = response.data;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data: ${response.message}')),
          );
        }
        print('Gagal memuat data: ${response.message}');
      }
    } catch (e) {
      log('Error loading transactions: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error:$e')));
      }
    }
  }

  Future<void> _loadIncome() async {
    final response = await _transactionRepo.getIncome();
    if (response.status == "success"){
      setState(() {
        _income = response.data.totalIncome;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 24.0),
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _transactions.isEmpty
                    ? const Center(child: Text('Belum ada transaksi'))
                    : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final tx = _transactions[index];

                        return _buildTransactionItem(tx);
                      },
                 ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const InsertPage()),
          );
          if (result == true) {
            _loadData();
          }
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  //Widget untuk rangkuman income, expense, dan balance
  Widget _buildSummaryCard(){
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Balance: Rp${_balance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Income: Rp${_income}',
                  style: const TextStyle(color:Colors.green, fontSize: 16),
                ),
                Text(
                  'Expense: Rp${_expense.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(
          tx.image ?? 'https://via.placeholder.com/150',
          errorBuilder: (context, error, StackTrace) {
            return const Icon(Icons.monetization_on);
          },
          fit: BoxFit.fitWidth,
        ),
      ),
      title: Text(
        tx.note ?? 'No Description',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tx.categoryName} •  ${tx.categoryType.toUpperCase()}',
            style: TextStyle(
              fontSize: 14,
              color: tx.categoryType == 'income' ? Colors.green : Colors.red,
            ),
          ),
          Text(
            tx.transactionDate.toString(),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          )
        ],
      ),
      trailing: Text(
        "${tx.categoryType == "income" ? '+' : '-'}Rp${tx.amount.toStringAsFixed(0)}",
        style: TextStyle(
          color: tx.categoryType == "income" ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      isThreeLine: true,
    );
  }
}