import 'package:flutter_test/flutter_test.dart';
import 'package:queue_management_app/models/queue_person.dart';

void main() {
  group('QueuePerson', () {
    test('formats queue numbers to at least three digits', () {
      const one = QueuePerson(
        id: 1,
        name: 'Alex',
        queueNumber: 1,
        status: 'Waiting',
        createdAt: '2026-01-01T10:00:00.000',
      );
      const nine = QueuePerson(
        id: 9,
        name: 'Sam',
        queueNumber: 9,
        status: 'Waiting',
        createdAt: '2026-01-01T10:00:00.000',
      );
      const oneHundred = QueuePerson(
        id: 100,
        name: 'Lee',
        queueNumber: 100,
        status: 'Waiting',
        createdAt: '2026-01-01T10:00:00.000',
      );

      expect(one.formattedQueueNumber, '001');
      expect(nine.formattedQueueNumber, '009');
      expect(oneHundred.formattedQueueNumber, '100');
    });
  });

  group('QueueStatistics', () {
    test('calculates counts and percentages from current records', () {
      final statistics = QueueStatistics.fromCounts(served: 4, waiting: 16);

      expect(statistics.total, 20);
      expect(statistics.servedPercentage, 20);
      expect(statistics.waitingPercentage, 80);
    });

    test('returns zero percentages for an empty queue', () {
      final statistics = QueueStatistics.fromCounts(served: 0, waiting: 0);

      expect(statistics.total, 0);
      expect(statistics.servedPercentage, 0);
      expect(statistics.waitingPercentage, 0);
    });
  });
}