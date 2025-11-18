import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/transaction_entity.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transaction_list_item.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().loadTransactions();
  }

  Future<void> _handleRefresh() async {
    await context.read<TransactionCubit>().loadTransactions();
  }

  void _showAddTransactionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransactionForm(),
    );
  }

  void _showEditTransactionDialog(TransactionEntity transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionForm(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TransactionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<TransactionCubit>().loadTransactions();
          }
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = state is TransactionLoaded
              ? state.transactions
              : <TransactionEntity>[];
          final totalExpense = transactions.fold<double>(
            0,
            (sum, transaction) => sum + transaction.amount,
          );
          final averageExpense = transactions.isEmpty
              ? 0
              : totalExpense / transactions.length;
          final lastTransaction = transactions.isEmpty
              ? null
              : transactions.first;

          final categoryTotals = <String, double>{};
          for (final transaction in transactions) {
            categoryTotals.update(
              transaction.category,
              (value) => value + transaction.amount,
              ifAbsent: () => transaction.amount,
            );
          }
          final topCategories = categoryTotals.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return Stack(
            children: [
              const _HomeBackgroundDecor(),
              RefreshIndicator(
                color: colorScheme.primary,
                onRefresh: _handleRefresh,
                child: SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HomeTopBar(
                                onAnalytics: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AnalyticsPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              _TotalExpenseCard(
                                totalExpense: totalExpense,
                                averageExpense: averageExpense.toDouble(),
                                lastTransaction: lastTransaction,
                              ),
                              if (topCategories.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Text(
                                  'Những danh mục chi nhiều nhất',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 90,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: math
                                        .min(topCategories.length, 5)
                                        .toInt(),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                      final entry = topCategories[index];
                                      return _CategoryBadge(
                                        category: entry.key,
                                        amount: entry.value,
                                      );
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(height: 32),
                              Text(
                                'Lịch sử giao dịch',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      if (transactions.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyState(
                            onActionTap: _showAddTransactionDialog,
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final transaction = transactions[index];
                              return TransactionListItem(
                                transaction: transaction,
                                onTap: () =>
                                    _showEditTransactionDialog(transaction),
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Text('Xác nhận'),
                                      content: const Text(
                                        'Bạn có chắc muốn xóa giao dịch này?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext),
                                          child: const Text('Hủy'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<TransactionCubit>()
                                                .delete(transaction.id!);
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text('Xóa'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }, childCount: transactions.length),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTransactionDialog,
        icon: const Icon(Icons.add),
        label: const Text('Giao dịch mới'),
      ),
    );
  }
}

class _HomeBackgroundDecor extends StatelessWidget {
  const _HomeBackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F5AF0), Color(0xFF5D2EEA)],
          begin: Alignment.topCenter,
          end: Alignment(0, 0.3),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  final VoidCallback onAnalytics;

  const _HomeTopBar({required this.onAnalytics});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                'Theo dõi tài chính của bạn hôm nay',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _GlassIconButton(icon: Icons.bar_chart_rounded, onTap: onAnalytics),
        const SizedBox(width: 12),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final email = authState is AuthAuthenticated
                ? authState.user.email
                : '';
            final initials = email.isNotEmpty ? email[0].toUpperCase() : '?';
            return PopupMenuButton<int>(
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 8,
              itemBuilder: (context) => [
                if (email.isNotEmpty)
                  PopupMenuItem<int>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tài khoản',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(email),
                      ],
                    ),
                  ),
                PopupMenuItem<int>(value: 1, child: const Text('Đăng xuất')),
              ],
              onSelected: (_) {
                context.read<AuthCubit>().logout();
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _TotalExpenseCard extends StatelessWidget {
  final double totalExpense;
  final double averageExpense;
  final TransactionEntity? lastTransaction;

  const _TotalExpenseCard({
    required this.totalExpense,
    required this.averageExpense,
    required this.lastTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng chi trong tháng',
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
          const SizedBox(height: 24),
          Row(
            children: [
              _StatPill(
                label: 'TB/GD',
                value: NumberFormat.compactCurrency(
                  locale: 'vi_VN',
                  symbol: '₫',
                ).format(averageExpense),
              ),
              const SizedBox(width: 16),
              if (lastTransaction != null)
                _StatPill(
                  label: lastTransaction!.category,
                  value: DateFormat(
                    AppConstants.dateFormat,
                  ).format(lastTransaction!.date),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  final double amount;

  const _CategoryBadge({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF7F5AF0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onActionTap;

  const _EmptyState({required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: const Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có giao dịch nào',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Bắt đầu ghi lại các khoản chi tiêu để theo dõi dòng tiền của bạn.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onActionTap,
            icon: const Icon(Icons.add),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            label: const Text('Thêm giao dịch đầu tiên'),
          ),
        ],
      ),
    );
  }
}
