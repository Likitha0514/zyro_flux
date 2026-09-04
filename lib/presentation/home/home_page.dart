import 'package:flutter/material.dart';

import '../../core/app_dependencies.dart';
import '../flux/flux_page.dart';
import '../zyro/zyro_page.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonViolet = Color(0xFF9B6DFF);

class HomePage extends StatefulWidget {
  final AppDependencies dependencies;

  const HomePage({super.key, required this.dependencies});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,

        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [neonViolet, neonPurple, neonCyan],
            ).createShader(bounds);
          },
          child: const Text(
            'ZYRO & FLUX',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF080A10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: neonViolet.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: neonViolet.withValues(alpha: 0.08),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [neonViolet, neonPurple, neonCyan],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: neonPurple.withValues(alpha: 0.25),
                      blurRadius: 12,
                    ),
                  ],
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'ZYRO'),
                  Tab(text: 'FLUX'),
                ],
              ),
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          ZyroPage(dependencies: widget.dependencies),
          FluxPage(dependencies: widget.dependencies),
        ],
      ),
    );
  }
}
