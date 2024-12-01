import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';

class AddTransactionScreen extends StatelessWidget {
  final _amountController = TextEditingController();
  String _type = 'recebimento';

  AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Transação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _type,
              items: ['recebimento', 'dívida']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                _type = value!;
              },
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await financeProvider.addTransaction(
                    authProvider.token!,
                    _type,
                    double.parse(_amountController.text),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erro ao adicionar transação')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
