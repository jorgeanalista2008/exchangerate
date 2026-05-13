class DolarModel {
  final String fuente;
  final String nombre;
  final double promedio;
  final DateTime? fechaActualizacion; // <--- NUEVO

  DolarModel({
    required this.fuente,
    required this.nombre,
    required this.promedio,
    this.fechaActualizacion,
  });

  factory DolarModel.fromJson(Map<String, dynamic> json) {
    return DolarModel(
      fuente: json['fuente'] ?? '',
      nombre: json['nombre'] ?? '',
      promedio: (json['promedio'] ?? 0).toDouble(),
      // Intentamos parsear la fecha si existe
      fechaActualizacion: json['fechaActualizacion'] != null 
          ? DateTime.tryParse(json['fechaActualizacion']) 
          : null,
    );
  }
}