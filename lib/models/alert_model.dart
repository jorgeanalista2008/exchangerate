class PriceAlert {
  int? id;
  String moneda; // 'paralelo' o 'oficial'
  double precioObjetivo;
  bool esMayor; // true = notifica cuando supera, false = cuando baja
  bool activa;
  DateTime fechaCreacion;
  DateTime? ultimaNotificacion;

  PriceAlert({
    this.id,
    required this.moneda,
    required this.precioObjetivo,
    required this.esMayor,
    this.activa = true,
    required this.fechaCreacion,
    this.ultimaNotificacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moneda': moneda,
      'precioObjetivo': precioObjetivo,
      'esMayor': esMayor ? 1 : 0,
      'activa': activa ? 1 : 0,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'ultimaNotificacion': ultimaNotificacion?.toIso8601String(),
    };
  }

  factory PriceAlert.fromMap(Map<String, dynamic> map) {
    return PriceAlert(
      id: map['id'],
      moneda: map['moneda'],
      precioObjetivo: map['precioObjetivo'],
      esMayor: map['esMayor'] == 1,
      activa: map['activa'] == 1,
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
      ultimaNotificacion: map['ultimaNotificacion'] != null 
          ? DateTime.parse(map['ultimaNotificacion']) 
          : null,
    );
  }

  String get condicionTexto => esMayor ? 'supere' : 'baje de';
  String get monedaTexto => moneda == 'paralelo' ? 'Paralelo' : 'Oficial';
}