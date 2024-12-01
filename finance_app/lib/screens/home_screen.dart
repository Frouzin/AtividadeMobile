import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo Financeiro')),
      body: FutureBuilder(
        future: financeProvider.fetchSummary(authProvider.token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          return Column(
            children: [
              Text('Total em caixa: R\$${financeProvider.total.toStringAsFixed(2)}'),
              Expanded(
                child: ListView.builder(
                  itemCount: financeProvider.transactions.length,
                  itemBuilder: (ctx, i) {
                    final transaction = financeProvider.transactions[i];
                    return ListTile(
                      title: Text(transaction.type),
                      subtitle: Text(transaction.createdAt.toString()),
                      trailing: Text('R\$${transaction.amount.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
