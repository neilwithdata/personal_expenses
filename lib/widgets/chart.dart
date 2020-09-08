import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';

import 'chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      // sum up all the transactions for the current weekday
      var sum = 0.0;
      for (var transaction in recentTransactions) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          sum += transaction.amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay)[0], 'amount': sum};
    });
  }

  double get totalSpend {
    return groupedTransactionValues.fold(0.0, (prev, e) => prev + (e['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: groupedTransactionValues.reversed.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(tx['day'].toString(), tx['amount'] as double,
                  totalSpend == 0.0 ? 0.0 : (tx['amount'] as double) / totalSpend),
            );
          }).toList(),
        ),
      ),
    );
  }
}
