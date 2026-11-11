import 'package:flutter/material.dart';
import 'package:presente/app/routes.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/check_in.dart';
import 'package:presente/screens/help_screen.dart';
import 'package:presente/services/check_in_service.dart';
import 'package:presente/services/contact_service.dart';
import 'package:presente/utils/formatters.dart';
import 'package:presente/widgets/big_button.dart';
import 'package:presente/widgets/status_card.dart';
import 'package:presente/widgets/status_style.dart';
import 'package:presente/widgets/today_weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onSeeWeather});

  final VoidCallback onSeeWeather;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CheckInService _checkIns = CheckInService();
  final ContactService _contacts = ContactService();

  CheckIn? _today;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final history = await _checkIns.history();
    if (!mounted) return;
    setState(() {
      _today = _checkIns.latestToday(history);
      _loading = false;
    });
  }

  Future<void> _register(CheckInStatus status, String message) async {
    await _checkIns.register(status);
    await _refresh();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Future<void> _openHelp() async {
    final contacts = await _contacts.list();
    if (!mounted) return;
    await Navigator.pushNamed(
      context,
      Routes.help,
      arguments: HelpArguments(
        contacts: _contacts.contactsToNotify(contacts),
      ),
    );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '${weekdayName(now)}, ${formatShortDate(now)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        _buildStatusCard(),
        const SizedBox(height: 24),
        BigButton(
          label: 'Estou bem',
          icon: Icons.check_circle,
          color: AppColors.success,
          height: 140,
          fontSize: 34,
          onPressed: () => _register(
            CheckInStatus.ok,
            'Que bom! Sua família foi avisada.',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BigButton(
                label: 'Mais tarde',
                icon: Icons.schedule,
                color: AppColors.warning,
                height: 90,
                fontSize: 20,
                onPressed: () => _register(
                  CheckInStatus.later,
                  'Tudo bem, vamos lembrar você mais tarde.',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BigButton(
                label: 'Preciso de ajuda',
                icon: Icons.emergency,
                color: AppColors.danger,
                height: 90,
                fontSize: 20,
                onPressed: _openHelp,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TodayWeatherCard(onTap: widget.onSeeWeather),
      ],
    );
  }

  Widget _buildStatusCard() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final today = _today;
    if (today == null) {
      return const StatusCard(
        title: 'Aguardando',
        message: 'Toque em "Estou bem" para avisar sua família.',
        icon: Icons.hourglass_empty,
        color: AppColors.neutral,
      );
    }
    final time = formatTime(today.time);
    switch (today.status) {
      case CheckInStatus.ok:
        return StatusCard(
          title: 'Você está bem',
          message: 'Avisado às $time.',
          icon: statusIcon(today.status),
          color: statusColor(today.status),
        );
      case CheckInStatus.later:
        return StatusCard(
          title: 'Mais tarde',
          message: 'Você pediu para ser lembrado às $time.',
          icon: statusIcon(today.status),
          color: statusColor(today.status),
        );
      case CheckInStatus.help:
        return StatusCard(
          title: 'Pedido de ajuda enviado',
          message: 'Sua família foi avisada às $time.',
          icon: statusIcon(today.status),
          color: statusColor(today.status),
        );
    }
  }
}
