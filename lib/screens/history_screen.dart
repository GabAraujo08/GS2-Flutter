import 'package:flutter/material.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/check_in.dart';
import 'package:presente/services/check_in_service.dart';
import 'package:presente/utils/formatters.dart';
import 'package:presente/widgets/status_style.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final CheckInService _service = CheckInService();

  List<CheckIn> _history = <CheckIn>[];
  CheckInStatus? _filter;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final history = await _service.history();
    if (!mounted) return;
    setState(() {
      _history = history;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _filter == null
        ? _history
        : _history.where((c) => c.status == _filter).toList();
    final options = <CheckInStatus?>[null, ...CheckInStatus.values];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '${_service.countOk(_history)} avisos de "Estou bem" nos últimos 30 dias',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            children: options.map((status) {
              return ChoiceChip(
                label: Text(
                  status?.label ?? 'Todos',
                  style: const TextStyle(fontSize: 16),
                ),
                selected: _filter == status,
                onSelected: (_) => setState(() => _filter = status),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Ainda não há registros. Toque em "Estou bem" na tela inicial.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildEntry(filtered[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEntry(CheckIn checkIn) {
    final color = statusColor(checkIn.status);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: color.withAlpha(40),
          child: Icon(statusIcon(checkIn.status), color: color, size: 30),
        ),
        title: Text(
          checkIn.status.label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        subtitle: Text(
          '${weekdayName(checkIn.time)}, ${formatShortDate(checkIn.time)} às ${formatTime(checkIn.time)}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
