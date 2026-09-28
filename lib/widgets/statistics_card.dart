import 'package:flutter/material.dart';

import '../models/queue_person.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key, required this.statistics});

  final QueueStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Queue overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatisticColumn(
                    label: 'TOTAL',
                    value: '${statistics.total}',
                    detail: 'people',
                    color: const Color(0xFF17231F),
                  ),
                ),
                Expanded(
                  child: _StatisticColumn(
                    label: 'SERVED',
                    value: '${statistics.served}',
                    detail: '${statistics.servedPercentage.toStringAsFixed(0)}%',
                    color: const Color(0xFF176B59),
                  ),
                ),
                Expanded(
                  child: _StatisticColumn(
                    label: 'WAITING',
                    value: '${statistics.waiting}',
                    detail: '${statistics.waitingPercentage.toStringAsFixed(0)}%',
                    color: const Color(0xFFB56A17),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticColumn extends StatelessWidget {
  const _StatisticColumn({
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });

  final String label;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFF68736D),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          detail,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF68736D),
          ),
        ),
      ],
    );
  }
}