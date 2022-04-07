class Transactiox {
  final int? ejecutar; // dato requerido

  late String fecha;
  late String usuario;
  late int? seguimiento;
  late int? agenda;
  late int? documento;
  late int cuenta;
  late int valor;
  late String observacion;
  late String registro;
  late int mascara;
  late String archivo0;
  late String archivo1;
  late String archivo2;
  late String archivo3;

  late String desAgenda;
  late String parAgenda0;
  late String parAgenda1;
  late String parAgenda2;
  late String parAgenda3;

  late String desMascara;

  late String desDocumento;

  late String desCuenta;

  late String desSeguimiento;

  Transactiox({
    this.ejecutar,
    required this.fecha,
    required this.usuario,
    required this.seguimiento,
    this.agenda,
    this.documento,
    required this.cuenta,
    required this.valor,
    required this.observacion,
    required this.registro,
    required this.mascara,
    required this.archivo0,
    required this.archivo1,
    required this.archivo2,
    required this.archivo3,
    required this.desAgenda,
    required this.parAgenda0,
    required this.parAgenda1,
    required this.parAgenda2,
    required this.parAgenda3,
    required this.desMascara,
    required this.desDocumento,
    required this.desCuenta,
    required this.desSeguimiento,
  });

  Transactiox.fromMap(Map<String, dynamic> tra)
      : ejecutar = tra["ejecutar"],
        fecha = tra["fecha"],
        usuario = tra["usuario"],
        seguimiento = tra["seguimiento"],
        agenda = tra["agenda"],
        documento = tra["documento"],
        cuenta = tra["cuenta"],
        valor = tra["valor"],
        observacion = tra["observacion"],
        registro = tra["registro"],
        mascara = tra["mascara"],
        archivo0 = tra["archivo0"],
        archivo1 = tra["archivo1"],
        archivo2 = tra["archivo2"],
        archivo3 = tra["archivo3"],
        desAgenda = tra["desAgenda"],
        parAgenda0 = tra["parAgenda0"],
        parAgenda1 = tra["parAgenda1"],
        parAgenda2 = tra["parAgenda2"],
        parAgenda3 = tra["parAgenda3"],
        desMascara = tra["desMascara"],
        desDocumento = tra["desDocumento"],
        desCuenta = tra["desCuenta"],
        desSeguimiento = tra["desSeguimiento"];

  Map<String, Object?> toMap() {
    return {
      'ejecutar': ejecutar,
      'fecha': fecha,
      'usuario': usuario,
      'seguimiento': seguimiento,
      'agenda': agenda,
      'documento': documento,
      'cuenta': cuenta,
      'valor': valor,
      'observacion': observacion,
      'registro': registro,
      'mascara': mascara,
      'archivo0': archivo0,
      'archivo1': archivo1,
      'archivo2': archivo2,
      'archivo3': archivo3,
      'desAgenda': desAgenda,
      'parAgenda0': parAgenda0,
      'parAgenda1': parAgenda1,
      'parAgenda2': parAgenda2,
      'parAgenda3': parAgenda3,
      'desMascara': desMascara,
      'desDocumento': desDocumento,
      'desCuenta': desCuenta,
      'desSeguimiento': desSeguimiento,
    };
  }
}
