import 'package:flutter/material.dart';
import 'package:presente/app/routes.dart';
import 'package:presente/screens/contacts_screen.dart';
import 'package:presente/screens/history_screen.dart';
import 'package:presente/screens/home_screen.dart';
import 'package:presente/screens/weather_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const List<String> _titles = [
    'Presente',
    'Contatos',
    'Clima e cuidados',
    'Histórico',
  ];

  int _index = 0;

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return HomeScreen(onSeeWeather: () => setState(() => _index = 2));
      case 1:
        return const ContactsScreen();
      case 2:
        return const WeatherScreen();
      default:
        return const HistoryScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Rever a introdução',
            onPressed: () => Navigator.pushNamed(context, Routes.onboarding),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts),
            label: 'Contatos',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Clima',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}
