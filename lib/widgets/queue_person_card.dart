import 'package:flutter/material.dart';

import '../models/queue_person.dart';

class QueuePersonCard extends StatelessWidget {
  const QueuePersonCard({super.key, required this.person});

  final QueuePerson person;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F2EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '#${person.formattedQueueNumber}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF176B59),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Waiting',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF68736D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_time, color: Color(0xFF176B59)),
          ],
        ),
      ),
    );
  }
}