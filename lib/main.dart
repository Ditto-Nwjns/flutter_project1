import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'package:flutter_5a/views/dashboard.dart'; // NavBar yg sudah terpakai di project-mu
import 'views/profile.dart';
import 'views/chat_page.dart';
import 'views/laporkan_page.dart';
import 'views/edukasi_page.dart';

void main() => runApp(const SabdaApp());

class SabdaApp extends StatelessWidget {
  const SabdaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseDark = ThemeData.dark();
    return MaterialApp(
      title: 'SABDA App',
      debugShowCheckedModeBanner: false,
      theme: baseDark.copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        textTheme: baseDark.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: baseDark.colorScheme.copyWith(
          primary: AppColors.primary,
          secondary: AppColors.primary,
        ),
      ),
      // Login sebagai halaman awal
      routes: {
        '/': (_) => const LoginPage(),
        // Teruskan username dari arguments ke HomeShell
        '/home': (ctx) {
          final usernameArg = (ModalRoute.of(ctx)?.settings.arguments as String?)?.trim();
          return HomeShell(initialUsername: (usernameArg?.isNotEmpty == true) ? usernameArg! : 'Sandi Arta');
        },
        // Profil via push (opsional), kalau dipakai, kirim argumen username saat memanggil
        '/profil': (ctx) {
          final name = (ModalRoute.of(ctx)?.settings.arguments as String?) ?? 'Sandi Arta';
          return ProfilePage(username: name);
        },
        '/chat': (_) => const ChatPage(),
        '/lapor': (_) => const LaporkanPage(),
        '/edukasi': (_) => const EdukasiPage(),
      },
    );
  }
}

// ------------------------------ HomeShell --------------------------------
class HomeShell extends StatefulWidget {
  final String initialUsername;
  const HomeShell({super.key, required this.initialUsername});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle; // time/desc
  ActivityItem(this.icon, this.title, this.subtitle);
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  late String _username;
  final List<ActivityItem> _recentActivities = <ActivityItem>[
    ActivityItem(Icons.forum_outlined, 'Chat dengan Konselor A', 'Kemarin'),
    ActivityItem(Icons.menu_book_outlined, 'Baca artikel: Mengenal Kekerasan', '3 hari lalu'),
  ];

  @override
  void initState() {
    super.initState();
    _username = widget.initialUsername;
  }

  Future<void> _openLaporkan() async {
    final result = await Navigator.pushNamed(context, '/lapor');
    if (result is ReportResult) {
      setState(() {
        _recentActivities.insert(
          0,
          ActivityItem(
            Icons.check_circle_outline,
            'Laporan: ${result.judul}',
            'Baru saja',
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan ditambahkan ke Aktivitas Terakhir')),
      );
    }
  }

  void _openProfileTab() => setState(() => _selectedIndex = 1);

  @override
  Widget build(BuildContext context) {
    final pages = [
      BerandaPage(
        username: _username,
        recentActivities: _recentActivities,
        onOpenLaporkan: _openLaporkan,
        onOpenProfileTab: _openProfileTab,
      ),
      ProfilePage(
        username: _username,
        onNameChanged: (v) => setState(() => _username = v),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: SabdaNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ------------------------------ BerandaPage -------------------------------
class BerandaPage extends StatelessWidget {
  final String username;
  final List<ActivityItem> recentActivities;
  final VoidCallback onOpenLaporkan;
  final VoidCallback onOpenProfileTab;

  const BerandaPage({
    super.key,
    required this.username,
    required this.recentActivities,
    required this.onOpenLaporkan,
    required this.onOpenProfileTab,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hallo,", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text(
                  "Selamat datang di SABDA!",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(166, 255, 255, 255)),
                ),
              ],
            ),
            GestureDetector(
              onTap: onOpenProfileTab, // (why): langsung ke tab Profil agar bisa ubah nama & sinkron
              child: const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/img/Pak_Datuk.jpeg'),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Box Motivasi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.motivationBg, borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [
              Icon(Icons.shield_outlined, size: 32, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Jangan takut bercerita, karena SABDA ruang amannya untuk berbagi cerita",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // New Chat — full width & tinggi lebih besar
          FeatureCard(
            icon: Icons.chat,
            title: "New Chat",
            subtitle: "Mulai percakapan baru.",
            color: const Color.fromARGB(255, 0, 66, 97),
            height: 140,
            onTap: () => Navigator.pushNamed(context, '/chat'),
          ),

          const SizedBox(height: 12),

          // Baris 2: Laporkan & Edukasi
          Row(children: [
            Expanded(
              child: FeatureCard(
                icon: Icons.report_gmailerrorred_rounded,
                title: "Laporkan",
                subtitle: "Sampaikan laporan.",
                color: const Color.fromARGB(255, 79, 0, 0),
                onTap: onOpenLaporkan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FeatureCard(
                icon: Icons.school,
                title: "Edukasi",
                subtitle: "Materi & panduan.",
                color: const Color.fromARGB(255, 0, 59, 3),
                onTap: () => Navigator.pushNamed(context, '/edukasi'),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // ===== Aktivitas Terakhir (DINAMIS) =====
          Text("Aktivitas Terakhir", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            color: const Color.fromARGB(255, 12, 0, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recentActivities.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final it = recentActivities[i];
                return ListTile(
                  leading: Icon(it.icon),
                  title: Text(it.title),
                  subtitle: Text(it.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Tips Keamanan
          Text("Tips Keamanan", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF10203A), borderRadius: BorderRadius.circular(16)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bullet(text: "Jaga kerahasiaan identitas saat bercerita."),
                _Bullet(text: "Laporkan jika ada perilaku mengganggu."),
                _Bullet(text: "Gunakan kata sandi yang kuat & unik."),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("•  "),
        Expanded(child: Text(text)),
      ]),
    );
  }
}

// ------------------------------ FeatureCard -------------------------------
class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final double height;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.height = 100,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> with SingleTickerProviderStateMixin {
  bool _active = false;
  late final AnimationController _c;
  late final Animation<double> _scale;

  bool get _isMobile {
    final p = Theme.of(context).platform;
    return p == TargetPlatform.android || p == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _start() { setState(() => _active = true); _c.forward(); }
  void _stop()  { setState(() => _active = false); _c.reverse(); }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(12),
      height: widget.height,
      width: double.infinity, // full-width saat di Column
      decoration: BoxDecoration(
        color: _active ? widget.color.withOpacity(0.9) : widget.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _active ? const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))] : const [],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(widget.icon, size: 28, color: Colors.white),
        const SizedBox(height: 8),
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ]),
    );

    final interactive = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        onHighlightChanged: (v) => v ? _start() : _stop(),
        child: content,
      ),
    );

    return _isMobile
        ? GestureDetector(onTapDown: (_) => _start(), onTapUp: (_) => _stop(), onTapCancel: _stop, child: ScaleTransition(scale: _scale, child: interactive))
        : MouseRegion(onEnter: (_) => _start(), onExit: (_) => _stop(), cursor: SystemMouseCursors.click, child: ScaleTransition(scale: _scale, child: interactive));
  }
}

class AppColors {
  static const bg = Color.fromARGB(255, 4, 0, 36);
  static const primary = Color(0xFF6EA8FE);
  static const motivationBg = Color.fromARGB(255, 0, 23, 61);
}