import 'package:flutter/material.dart';

void main() {
  runApp(const MedMindApp());
}

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage(this.code, this.name, this.nativeName, this.flag);
}

class MedMindApp extends StatefulWidget {
  const MedMindApp({super.key});

  @override
  State<MedMindApp> createState() => _MedMindAppState();
}

class _MedMindAppState extends State<MedMindApp> {
  AppLanguage language = const AppLanguage('en', 'English', 'English', '🇬🇧');

  void setLanguage(AppLanguage value) {
    setState(() => language = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedMind AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: WelcomeScreen(
        language: language,
        onLanguageChanged: setLanguage,
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const WelcomeScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = {
      'en': ['Your medical knowledge.', 'One intelligent place.', 'ENTER MEDMIND'],
      'fr': ['Vos connaissances médicales.', 'Un seul espace intelligent.', 'ENTRER DANS MEDMIND'],
      'ar': ['معرفتك الطبية.', 'مكان ذكي واحد.', 'ادخل إلى MedMind'],
    }[widget.language.code]!;

    return Scaffold(
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF071018), Color(0xFF102A32), Color(0xFF071018)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton<AppLanguage>(
                      icon: Text(widget.language.flag, style: const TextStyle(fontSize: 24)),
                      onSelected: widget.onLanguageChanged,
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: AppLanguage('ar', 'Arabic', 'العربية', '🇸🇦'),
                          child: Text('🇸🇦 العربية'),
                        ),
                        PopupMenuItem(
                          value: AppLanguage('fr', 'French', 'Français', '🇫🇷'),
                          child: Text('🇫🇷 Français'),
                        ),
                        PopupMenuItem(
                          value: AppLanguage('en', 'English', 'English', '🇬🇧'),
                          child: Text('🇬🇧 English'),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) {
                      final scale = 1 + controller.value * 0.06;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.tealAccent.withOpacity(.65), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.tealAccent.withOpacity(.22),
                                blurRadius: 40,
                                spreadRadius: 8,
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text('🧠', style: TextStyle(fontSize: 72)),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'MEDMIND AI',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${labels[0]}\n${labels[1]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(language: widget.language),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(labels[2]),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Medical education • AI-assisted learning',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AppLanguage language;

  const HomeScreen({super.key, required this.language});

  String t(String en, String fr, String ar) {
    return language.code == 'ar' ? ar : language.code == 'fr' ? fr : en;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDMIND AI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            t('What do you want to understand today?',
              'Que voulez-vous comprendre aujourd’hui ?',
              'ماذا تريد أن تفهم اليوم؟'),
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: t('Ask MedMind anything...', 'Demandez à MedMind...', 'اسأل MedMind أي شيء...'),
              prefixIcon: const Icon(Icons.auto_awesome),
              suffixIcon: const Icon(Icons.mic_none),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 26),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
            children: [
              FeatureCard(
                icon: Icons.upload_file_rounded,
                title: t('Upload PDF', 'Importer PDF', 'رفع PDF'),
                subtitle: t('Study your lecture', 'Étudier votre cours', 'ادرس محاضرتك'),
              ),
              FeatureCard(
                icon: Icons.psychology_alt_outlined,
                title: t('Explain', 'Expliquer', 'اشرح'),
                subtitle: t('Understand deeply', 'Comprendre en profondeur', 'افهم بعمق'),
              ),
              FeatureCard(
                icon: Icons.quiz_outlined,
                title: t('Quiz me', 'Quiz', 'اختبرني'),
                subtitle: t('Medical QCM', 'QCM médical', 'أسئلة طبية'),
              ),
              FeatureCard(
                icon: Icons.style_outlined,
                title: t('Flashcards', 'Flashcards', 'بطاقات'),
                subtitle: t('Remember faster', 'Mémoriser plus vite', 'احفظ أسرع'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            t('Continue studying', 'Continuer à étudier', 'واصل الدراسة'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.favorite_outline)),
              title: const Text('Cardiovascular Physiology'),
              subtitle: Text(t('No lecture uploaded yet', 'Aucun cours importé', 'لم يتم رفع درس بعد')),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Educational AI only — verify important medical information with trusted academic sources.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30),
              const Spacer(),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white60)),
            ],
          ),
        ),
      ),
    );
  }
}
