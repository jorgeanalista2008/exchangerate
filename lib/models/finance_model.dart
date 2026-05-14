class FinanceTransaction {
  int? id;
  String tipo; // 'ingreso' o 'egreso'
  String concepto;
  double monto;
  String moneda; // 'USD' o 'VES'
  String categoria;
  DateTime fecha;
  String? nota;

  FinanceTransaction({
    this.id,
    required this.tipo,
    required this.concepto,
    required this.monto,
    required this.moneda,
    required this.categoria,
    required this.fecha,
    this.nota,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'concepto': concepto,
      'monto': monto,
      'moneda': moneda,
      'categoria': categoria,
      'fecha': fecha.toIso8601String(),
      'nota': nota,
    };
  }

  factory FinanceTransaction.fromMap(Map<String, dynamic> map) {
    return FinanceTransaction(
      id: map['id'],
      tipo: map['tipo'],
      concepto: map['concepto'],
      monto: map['monto'],
      moneda: map['moneda'],
      categoria: map['categoria'],
      fecha: DateTime.parse(map['fecha']),
      nota: map['nota'],
    );
  }
}

class FinancialSummary {
  double totalIngresosUSD;
  double totalIngresosVES;
  double totalEgresosUSD;
  double totalEgresosVES;
  double balanceUSD;
  double balanceVES;

  FinancialSummary({
    this.totalIngresosUSD = 0,
    this.totalIngresosVES = 0,
    this.totalEgresosUSD = 0,
    this.totalEgresosVES = 0,
    this.balanceUSD = 0,
    this.balanceVES = 0,
  });
}