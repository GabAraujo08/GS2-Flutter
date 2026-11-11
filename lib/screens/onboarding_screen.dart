import 'package:flutter/material.dart';
import 'package:presente/app/routes.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/services/storage_service.dart';
import 'package:presente/widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      icon: Icons.touch_app,
      title: 'Um toque por dia',
      description:
          'Todo dia você toca no botão "Estou bem". Pronto: sua família fica sabendo que está tudo certo.',
    ),
    OnboardingPageData(
      icon: Icons.health_and_safety,
      title: 'Ajuda quando precisar',
      description:
          'Se passar mal, toque em "Preciso de ajuda". O app avisa a família e deixa o 192 a um toque.',
    ),
    OnboardingPageData(
      icon: Icons.family_restroom,
      title: 'Perto de quem você ama',
      description:
          'Veja o clima, receba cuidados para o dia e ligue para quem você quiser com um só toque.',
    ),
  ];

  final StorageService _storage = StorageService();
  final PageController _controller = PageController();

  int _currentPage = 0;
  bool _dontShowAgain = false;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreference() async {
    final skip = await _storage.shouldSkipOnboarding();
    if (!mounted) return;
    setState(() => _dontShowAgain = skip);
  }

  void _previous() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_isLastPage) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await _storage.setSkipOnboarding(_dontShowAgain);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return OnboardingPageContent(data: _pages[index]);
                },
              ),
            ),
            _buildIndicators(),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _dontShowAgain,
              onChanged: (value) => setState(() => _dontShowAgain = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Não mostrar novamente',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: _currentPage > 0
                        ? OutlinedButton(
                            onPressed: _previous,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 64),
                              textStyle: const TextStyle(fontSize: 22),
                            ),
                            child: const Text('Voltar'),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 64),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(_isLastPage ? 'Começar' : 'Avançar'),
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

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(_pages.length, (index) {
        final active = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 28 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
