import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import 'package:go_router/go_router.dart';
import "features/dashboard/dashboard_screen.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _launchOperation(BuildContext context) {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Lottie animation
            Stack(
              children: [
                Container(
                  color: theme.primaryColor,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  child: Column(
                    children: [
                      Lottie.asset(
                        'lottie/rocket.json', // Download a free rocket Lottie file and place in assets
                        height: 120,
                        repeat: true,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Take Charge of Summer. The Dad Way.',
                        style: theme.textTheme.headlineLarge!.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'All-in-one family mission control: schedule, chores, and learning—all before breakfast.',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          // primary: theme.accentColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _launchOperation(context),
                        icon: Icon(Icons.rocket_launch),
                        label: Text(
                          'Launch Operation Summer',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Icon(
                    Icons.sunny,
                    color: Colors.yellow.shade600,
                    size: 40,
                  ),
                ),
              ],
            ),
            FeatureSection(),
            Divider(height: 48, thickness: 1.5, indent: 32, endIndent: 32),
            PoweredBySection(),
            Divider(height: 48, thickness: 1.5, indent: 32, endIndent: 32),
            MadeForFamiliesSection(),
            Divider(height: 48, thickness: 1.5, indent: 32, endIndent: 32),
            StartTodaySection(onLaunch: () => _launchOperation(context)),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

class FeatureSection extends StatelessWidget {
  final List<_Feature> features = [
    _Feature(
      icon: Icons.calendar_month,
      title: "Command the Calendar",
      description:
          "View and manage the full family schedule, powered by Google Calendar.",
      lottie: 'assets/calendar.json',
    ),
    _Feature(
      icon: Icons.cleaning_services,
      title: "Chores? Handled.",
      description:
          "Assign and track chores. Kids earn points and unlock real-world rewards.",
      lottie: 'assets/chores.json',
    ),
    _Feature(
      icon: Icons.ondemand_video,
      title: "Daily Video Briefings",
      description:
          "Each child gets a custom morning video with schedule and fun facts.",
      lottie: 'assets/video.json',
    ),
    _Feature(
      icon: Icons.draw,
      title: "Coloring + Worksheets",
      description: "AI-generated, printable activities based on daily themes.",
      lottie: 'assets/coloring.json',
    ),
    _Feature(
      icon: Icons.sports_handball,
      title: "Exercise & Projects",
      description: "Group challenges to get moving and create together.",
      lottie: 'assets/exercise.json',
    ),
    _Feature(
      icon: Icons.music_note,
      title: "Song of the Day",
      description:
          "Curated YouTube songs to get the family singing and smiling.",
      lottie: 'assets/music.json',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Text(
            "Built for Tactical Dads (and Awesome Moms)",
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: features.map((f) => FeatureCard(feature: f)).toList(),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final _Feature feature;
  FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Lottie.asset(feature.lottie, height: 60, repeat: true),
            SizedBox(height: 12),
            Text(
              feature.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              feature.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class PoweredBySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        children: [
          Text(
            "Powered by OpenAI + Google",
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "We use OpenAI (GPT-4o + DALL·E + TTS) to generate smart content, and Google APIs to connect your family calendar, Drive, and YouTube. It's serious tech, made simple.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class MadeForFamiliesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        children: [
          Text(
            "Made for Real Families",
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Operation Summer was built by dads tired of sticky notes and group texts. Whether you’re in command full-time or running weekend ops, this app keeps your mission on track.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class StartTodaySection extends StatelessWidget {
  final VoidCallback onLaunch;
  const StartTodaySection({required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        children: [
          Text(
            'Start Today. No Manuals Required.',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            children: const [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Free to try'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Works on all devices'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Easy Google login'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Big Dad Energy. Big Kid Fun. Zero Summer Slumps.',
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onLaunch,
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Launch Operation Summer'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        '© 2025 Operation Summer',
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final String lottie;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.lottie,
  });
}
