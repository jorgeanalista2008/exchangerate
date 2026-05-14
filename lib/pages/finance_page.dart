import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../core/theme_provider.dart';
import '../database/finance_database.dart';
import '../models/finance_model.dart';
import '../molecules/balance_card.dart';
import '../molecules/transaction_form.dart';
import '../molecules/expense_chart.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> with SingleTickerProviderStateMixin {
  final FinanceDatabase _db = FinanceDatabase();
  FinancialSummary? _summary;
  List<FinanceTransaction> _transactions = [];
  Map<String, double> _expensesByCategory = {};
  bool _isLoading = true;
  
  // Filtros
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String _monedaFiltro = 'USD';
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final summary = await _db.getSummary(fechaInicio: _fechaInicio, fechaFin: _fechaFin);
      final transactions = await _db.getTransactions(
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        limit: 100,
      );
      final expenses = await _db.getExpensesByCategory(
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        moneda: _monedaFiltro,
      );
      
      setState(() {
        _summary = summary;
        _transactions = transactions;
        _expensesByCategory = expenses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addTransaction(FinanceTransaction transaction) async {
    await _db.insertTransaction(transaction);
    Navigator.pop(context);
    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Transacción guardada'), backgroundColor: Colors.green),
    );
  }

  Future<void> _deleteTransaction(int id, String concepto) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: Text('¿Eliminar "$concepto"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _db.deleteTransaction(id);
              Navigator.pop(ctx);
              _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Transacción eliminada'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fechaInicio != null && _fechaFin != null
          ? DateTimeRange(start: _fechaInicio!, end: _fechaFin!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );
    
    if (range != null) {
      setState(() {
        _fechaInicio = range.start;
        _fechaFin = range.end;
      });
      _loadData();
    }
  }

  void _clearFilters() {
    setState(() {
      _fechaInicio = null;
      _fechaFin = null;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkSurface, AppColors.darkSurface]
                  : [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _selectDateRange,
            tooltip: 'Filtrar por fechas',
          ),
          if (_fechaInicio != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: _clearFilters,
              tooltip: 'Quitar filtros',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Balance', icon: Icon(Icons.account_balance, size: 18)),
            Tab(text: 'Gráficos', icon: Icon(Icons.pie_chart, size: 18)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de filtros activos
                if (_fechaInicio != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.primaryColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_alt, size: 16, color: AppColors.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormat('dd/MM/yy').format(_fechaInicio!)} - ${DateFormat('dd/MM/yy').format(_fechaFin!)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.primaryColor),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Quitar', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                
                // Contenido principal
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab Balance
                      RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (_summary != null)
                              BalanceCard(
                                  summary: _summary!,
                                  isDark: isDark,
                                  expensesByCategory: _expensesByCategory, // ← Agregar esto
                              ),
                          const SizedBox(height: 20),
                            Text('Últimas Transacciones',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
                            const SizedBox(height: 12),
                            ..._transactions.map((t) => _buildTransactionItem(t, isDark)),
                          ],
                        ),
                      ),
                      
                      // Tab Gráficos
                      RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            // Selector de moneda para gráfico
                            Row(
                              children: [
                                const Text('Moneda:', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 12),
                                ChoiceChip(
                                  label: const Text('USD'),
                                  selected: _monedaFiltro == 'USD',
                                  onSelected: (v) {
                                    setState(() => _monedaFiltro = 'USD');
                                    _loadData();
                                  },
                                  selectedColor: AppColors.primaryColor,
                                  labelStyle: TextStyle(color: _monedaFiltro == 'USD' ? Colors.white : null),
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('VES'),
                                  selected: _monedaFiltro == 'VES',
                                  onSelected: (v) {
                                    setState(() => _monedaFiltro = 'VES');
                                    _loadData();
                                  },
                                  selectedColor: AppColors.primaryColor,
                                  labelStyle: TextStyle(color: _monedaFiltro == 'VES' ? Colors.white : null),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('Gastos por Categoría',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
                            const SizedBox(height: 16),
                            ExpenseChart(
                              expensesByCategory: _expensesByCategory,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Nueva Transacción')),
                body: TransactionForm(onSave: _addTransaction),
              ),
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionItem(FinanceTransaction t, bool isDark) {
    return Dismissible(
      key: Key(t.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Eliminar'),
            content: Text('¿Eliminar "${t.concepto}"?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        await _db.deleteTransaction(t.id!);
        _loadData();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: t.tipo == 'ingreso' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              t.tipo == 'ingreso' ? Icons.arrow_downward : Icons.arrow_upward,
              color: t.tipo == 'ingreso' ? Colors.green : Colors.red,
            ),
          ),
          title: Text(t.concepto, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(
            '${t.categoria} • ${DateFormat('dd/MM/yyyy').format(t.fecha)} • ${t.moneda}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${t.tipo == 'ingreso' ? "+" : "-"}${t.monto.toStringAsFixed(2)}',
                style: TextStyle(
                  color: t.tipo == 'ingreso' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[300], size: 20),
                onPressed: () => _deleteTransaction(t.id!, t.concepto),
              ),
            ],
          ),
        ),
      ),
    );
  }
}