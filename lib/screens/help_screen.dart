import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/check_in.dart';
import 'package:presente/models/contact.dart';
import 'package:presente/services/check_in_service.dart';
import 'package:presente/services/phone_service.dart';
import 'package:presente/widgets/big_button.dart';
import 'package:presente/widgets/call_helper.dart';

class HelpArguments {
  const HelpArguments({required this.contacts});

  final List<Contact> contacts;
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, required this.args});

  final HelpArguments args;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static const int _countdownSeconds = 5;

  final CheckInService _checkIns = CheckInService();

  Timer? _timer;
  int _remaining = _countdownSeconds;
  bool _sent = false;

  String get _contactNames {
    return widget.args.contacts.map((c) => c.name).join(', ');
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        _confirmHelp();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  Future<void> _confirmHelp() async {
    await _checkIns.register(CheckInStatus.help);
    if (!mounted) return;
    setState(() {
      _remaining = 0;
      _sent = true;
    });
  }

  void _callEmergency() {
    startCall(
      context,
      name: 'SAMU (192)',
      number: PhoneService.emergencyNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preciso de ajuda')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _sent ? _buildSent() : _buildCountdown(),
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return Column(
      children: [
        const Spacer(),
        const Text(
          'Vamos avisar sua família em',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _remaining / _countdownSeconds,
                  strokeWidth: 12,
                  color: AppColors.danger,
                  backgroundColor: Colors.black12,
                ),
              ),
              Text(
                '$_remaining',
                style: const TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Avisando: $_contactNames',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const Spacer(),
        BigButton(
          label: 'Ligar 192 agora',
          icon: Icons.call,
          color: AppColors.danger,
          height: 80,
          fontSize: 24,
          onPressed: _callEmergency,
        ),
        const SizedBox(height: 12),
        BigButton(
          label: 'Cancelar',
          icon: Icons.close,
          color: AppColors.neutral,
          height: 80,
          fontSize: 24,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSent() {
    final contacts = widget.args.contacts;
    final firstContact = contacts.isEmpty ? null : contacts.first;
    return Column(
      children: [
        const Spacer(),
        const Icon(Icons.check_circle, size: 110, color: AppColors.success),
        const SizedBox(height: 16),
        const Text(
          'Pedido de ajuda enviado',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Avisamos: $_contactNames',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        const Spacer(),
        BigButton(
          label: 'Ligar 192 (SAMU)',
          icon: Icons.call,
          color: AppColors.danger,
          height: 80,
          fontSize: 24,
          onPressed: _callEmergency,
        ),
        if (firstContact != null) ...[
          const SizedBox(height: 12),
          BigButton(
            label: 'Ligar para ${firstContact.name}',
            icon: Icons.phone,
            color: AppColors.primary,
            height: 80,
            fontSize: 22,
            onPressed: () => startCall(
              context,
              name: firstContact.name,
              number: firstContact.phone,
            ),
          ),
        ],
        const SizedBox(height: 12),
        BigButton(
          label: 'Voltar',
          icon: Icons.arrow_back,
          color: AppColors.neutral,
          height: 70,
          fontSize: 22,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
