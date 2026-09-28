class QueuePerson {
  const QueuePerson({
    required this.id,
    required this.name,
    required this.queueNumber,
    required this.status,
    required this.createdAt,
    this.servedAt,
  });

  final int id;
  final String name;
  final int queueNumber;
  final String status;
  final String createdAt;
  final String? servedAt;

  String get formattedQueueNumber => queueNumber.toString().padLeft(3, '0');

  factory QueuePerson.fromMap(Map<String, Object?> map) {
    return QueuePerson(
      id: map['id']! as int,
      name: map['name']! as String,
      queueNumber: map['queueNumber']! as int,
      status: map['status']! as String,
      createdAt: map['createdAt']! as String,
      servedAt: map['servedAt'] as String?,
    );
  }
}

class QueueStatistics {
  const QueueStatistics({
    required this.total,
    required this.served,
    required this.waiting,
  });

  final int total;
  final int served;
  final int waiting;

  double get servedPercentage => total == 0 ? 0 : served * 100 / total;

  double get waitingPercentage => total == 0 ? 0 : waiting * 100 / total;

  factory QueueStatistics.fromCounts({
    required int served,
    required int waiting,
  }) {
    return QueueStatistics(
      total: served + waiting,
      served: served,
      waiting: waiting,
    );
  }
}