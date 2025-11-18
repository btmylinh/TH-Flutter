import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_line_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnalyticsCubit>()..loadAnalytics(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Insight chi tiêu', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
              builder: (context, state) {
                if (state is AnalyticsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AnalyticsError) {
                  return _AnalyticsMessage(
                    icon: Icons.error_outline,
                    title: 'Không thể tải dữ liệu',
                    description: state.message,
                    actionLabel: 'Thử lại',
                    onAction: () =>
                        context.read<AnalyticsCubit>().loadAnalytics(),
                  );
                }

                if (state is AnalyticsLoaded) {
                  if (state.categoryStats.isEmpty &&
                      state.monthlyTrends.isEmpty) {
                    return const _AnalyticsMessage(
                      icon: Icons.auto_graph_rounded,
                      title: 'Chưa có dữ liệu phân tích',
                      description:
                          'Hãy thêm giao dịch để xem biểu đồ và xu hướng chi tiêu của bạn.',
                    );
                  }

                  final totalExpense = state.categoryStats.fold<double>(
                    0,
                    (sum, stat) => sum + stat.totalAmount,
                  );

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TotalInsightCard(totalExpense: totalExpense),
                              const SizedBox(height: 24),
                              if (state.categoryStats.isNotEmpty)
                                _InsightSection(
                                  title: 'Chi tiêu theo danh mục',
                                  child: CategoryPieChart(
                                    stats: state.categoryStats,
                                  ),
                                ),
                              if (state.categoryStats.isNotEmpty)
                                const SizedBox(height: 24),
                              if (state.monthlyTrends.isNotEmpty)
                                _InsightSection(
                                  title: 'Xu hướng chi tiêu',
                                  child: MonthlyLineChart(
                                    trends: state.monthlyTrends,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalInsightCard extends StatelessWidget {
  final double totalExpense;

  const _TotalInsightCard({required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng chi tiêu',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
            ).format(totalExpense),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.trending_up, color: Colors.greenAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Chi tiêu đang tăng nhẹ so với tháng trước',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InsightSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Trực tiếp',
                  style: TextStyle(
                    color: Color(0xFF7F5AF0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _AnalyticsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _AnalyticsMessage({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: Icon(icon, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
