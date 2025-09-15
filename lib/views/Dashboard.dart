import 'package:flutter/material.dart';

void main() => runApp(SabdaApp());

class SabdaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SABDA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 4, 0, 36),
        cardColor: Color(0xFF1E1E1E),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: BerandaPage(),
    );
  }
}

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hallo,", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      Text("Sandi Arta", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        "Selamat datang di SABDA!",
                        style: TextStyle(fontSize: 14, color: const Color.fromARGB(166, 255, 255, 255)),
                      ),
                    ],
                  ),
                  Icon(Icons.account_circle, size: 56, color: Colors.white),
                ],
              ),

              SizedBox(height: 24),

              // Box Motivasi
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 23, 61),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 32, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Jangan Takut bercerita, karena SABDA ruang amannya untuk berbagi cerita",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Kartu Fitur Row 1
              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.chat,
                      title: "New Chat",
                      subtitle: "Mulai percakapan baru sekarang.",
                      color: const Color.fromARGB(255, 0, 66, 97),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.report_gmailerrorred_rounded,
                      title: "Laporkan",
                      subtitle: "Sampaikan laporan.",
                      color: const Color.fromARGB(255, 79, 0, 0),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Kartu Fitur Row 2
              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.school,
                      title: "Edukasi",
                      subtitle: "Materi & panduan.",
                      color: const Color.fromARGB(255, 0, 59, 3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  _FeatureCardState createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> with SingleTickerProviderStateMixin {
  bool _isInteracting = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _isMobile =>
      Theme.of(context).platform == TargetPlatform.android ||
      Theme.of(context).platform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startInteraction() {
    setState(() => _isInteracting = true);
    _controller.forward();
  }

  void _stopInteraction() {
    setState(() => _isInteracting = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = AnimatedContainer(
      duration: Duration(milliseconds: 150),
      padding: EdgeInsets.all(12),
      height: 100,
      decoration: BoxDecoration(
        color: _isInteracting
            ? widget.color.withOpacity(0.9)
            : widget.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isInteracting
            ? [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ]
            : [],
      ),
      child: InkWell(
        onTap: () {
          print('Klik: ${widget.title}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, size: 28, color: Colors.white),
            SizedBox(height: 8),
            Text(widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            Text(widget.subtitle,
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );

    // Versi mobile: GestureDetector
    // Versi desktop/web: MouseRegion
    return _isMobile
        ? GestureDetector(
            onTapDown: (_) => _startInteraction(),
            onTapUp: (_) => _stopInteraction(),
            onTapCancel: () => _stopInteraction(),
            child: ScaleTransition(scale: _scaleAnimation, child: cardContent),
          )
        : MouseRegion(
            onEnter: (_) => _startInteraction(),
            onExit: (_) => _stopInteraction(),
            cursor: SystemMouseCursors.click,
            child: ScaleTransition(scale: _scaleAnimation, child: cardContent),
          );
  }
}
