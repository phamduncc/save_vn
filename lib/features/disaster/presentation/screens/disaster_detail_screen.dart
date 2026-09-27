import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/action_step_item.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/disaster_model.dart';

class DisasterDetailScreen extends StatefulWidget {
  final DisasterModel disaster;

  const DisasterDetailScreen({super.key, required this.disaster});

  @override
  State<DisasterDetailScreen> createState() => _DisasterDetailScreenState();
}

class _DisasterDetailScreenState extends State<DisasterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _parseHexColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return AppColors.emergencyRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disaster = widget.disaster;
    final primaryColor = _parseHexColor(disaster.color);

    return Scaffold(
      appBar: CustomAppBar(
        title: disaster.name,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryColor.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Text(disaster.icon, style: const TextStyle(fontSize: 44)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    disaster.tag,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  disaster.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  disaster.summary,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLightSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Don'ts Warning Banner
                    if (disaster.donts.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.emergencyRedDark.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.emergencyRed, width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.do_not_disturb_on_rounded,
                                    color: AppColors.emergencyRedLight, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'NEVER DO THIS',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.emergencyRedLight,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...disaster.donts.map(
                              (dont) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('⛔ ', style: TextStyle(fontSize: 13)),
                                    Expanded(
                                      child: Text(
                                        dont,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarHeaderDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.emergencyRed,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textLightSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: const [
                    Tab(text: 'BEFORE'),
                    Tab(text: 'DURING'),
                    Tab(text: 'AFTER'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPhaseList(disaster.phases.before, AppColors.safeGreenLight),
            _buildPhaseList(disaster.phases.during, AppColors.emergencyRedLight),
            _buildPhaseList(disaster.phases.after, AppColors.infoBlueLight),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseList(List<String> items, Color accentColor) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No guidance for this phase yet.',
            style: TextStyle(color: AppColors.textLightSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ActionStepItem(
          index: index + 1,
          text: items[index],
          accentColor: accentColor,
        );
      },
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarHeaderDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surfaceDark,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarHeaderDelegate oldDelegate) {
    return false;
  }
}
