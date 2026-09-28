import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/queue_person.dart';
import '../widgets/add_person_dialog.dart';
import '../widgets/queue_person_card.dart';
import '../widgets/statistics_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _database = DatabaseHelper.instance;

  List<QueuePerson> _waitingPeople = [];
  QueuePerson? _nowServing;
  QueueStatistics _statistics = const QueueStatistics(
    total: 0,
    served: 0,
    waiting: 0,
  );
  bool _isLoading = true;
  bool _isWorking = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool showLoading = false}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _loadFailed = false;
      });
    }

    try {
      final waitingPeople = await _database.getWaitingPeople();
      final nowServing = await _database.getLastServedPerson();
      final statistics = await _database.getStatistics();
      if (!mounted) return;
      setState(() {
        _waitingPeople = waitingPeople;
        _nowServing = nowServing;
        _statistics = statistics;
        _isLoading = false;
        _loadFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });
    }
  }

  Future<void> _addPerson() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const AddPersonDialog(),
    );
    if (name == null || _isWorking) return;

    setState(() => _isWorking = true);
    try {
      await _database.insertPerson(name);
      await _loadData();
      _showMessage('Added $name to the queue.');
    } catch (_) {
      _showMessage('Could not add this person. Please try again.');
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _serveNextPerson() async {
    if (_isWorking) return;
    setState(() => _isWorking = true);
    try {
      final person = await _database.getNextWaitingPerson();
      if (person == null) {
        _showMessage('No people waiting.');
        return;
      }

      final updated = await _database.servePerson(person.id);
      if (updated == 0) {
        _showMessage('That person is no longer waiting. Refresh and try again.');
        return;
      }
      await _loadData();
      _showMessage('Now serving ${person.name}.');
    } catch (_) {
      _showMessage('Could not serve the next person. Please try again.');
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _deleteServedPeople() async {
    if (_isWorking) return;
    if (_statistics.served == 0) {
      _showMessage('No served people to delete.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete served people?'),
        content: Text(
          'This will permanently remove ${_statistics.served} served '
          'records. Waiting people will remain in the queue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete served'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isWorking = true);
    try {
      final deletedCount = await _database.deleteServedPeople();
      await _loadData();
      _showMessage('Deleted $deletedCount served records.');
    } catch (_) {
      _showMessage('Could not delete served people. Please try again.');
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadFailed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Queue Manager')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storage_rounded, size: 40),
                const SizedBox(height: 12),
                Text(
                  'Your queue could not be loaded.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _loadData(showLoading: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Queue Manager',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh queue',
            onPressed: _isWorking ? null : () => _loadData(showLoading: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Manage your waiting queue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF68736D),
              ),
            ),
            const SizedBox(height: 20),
            StatisticsCard(statistics: _statistics),
            const SizedBox(height: 16),
            _NowServingCard(person: _nowServing),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Waiting queue',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${_waitingPeople.length} waiting',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF68736D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_waitingPeople.isEmpty)
              const _EmptyQueueMessage()
            else
              ..._waitingPeople.map(
                (person) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: QueuePersonCard(person: person),
                ),
              ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _isWorking ? null : _deleteServedPeople,
                icon: const Icon(Icons.delete_outline),
                label: Text('Delete served people (${_statistics.served})'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF9B3931),
                ),
              ),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isWorking ? null : _addPerson,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add person'),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: FilledButton.icon(
          onPressed: _isWorking ? null : _serveNextPerson,
          icon: _isWorking
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.arrow_forward_rounded),
          label: Text(_isWorking ? 'Please wait' : 'Next person'),
        ),
      ),
    );
  }
}

class _NowServingCard extends StatelessWidget {
  const _NowServingCard({required this.person});

  final QueuePerson? person;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF176B59),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.campaign_outlined,
              color: Color(0xFFC9EB78),
              size: 28,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOW SERVING',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFFC9EB78),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    person == null
                        ? 'No one served yet'
                        : '${person!.name}  ·  #${person!.formattedQueueNumber}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyQueueMessage extends StatelessWidget {
  const _EmptyQueueMessage();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            const Icon(
              Icons.groups_2_outlined,
              size: 34,
              color: Color(0xFF68736D),
            ),
            const SizedBox(height: 8),
            Text(
              'No people in the queue',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add someone to start the line.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF68736D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}