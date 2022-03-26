class
Record {
  final int? registro;  // dato requerido
  final String descripcion;
  final int tabla;
  final String parametro0;
  final String parametro1;
  final String parametro2;
  final String parametro3;

  Record(
      { this.registro,
        required this.descripcion,
        required this.tabla,
        required this.parametro0,
        required this.parametro1,
        required this.parametro2,
        required this.parametro3,
      });

  Record.fromMap(Map<String, dynamic> rec)
      : registro = rec["registro"],
        descripcion = rec["descripcion"],
        tabla = rec["tabla"],
        parametro0 = rec["parametro0"],
        parametro1 = rec["parametro1"],
        parametro2 = rec["parametro2"],
        parametro3 = rec["parametro3"];


  Map<String, Object?> toMap() {
    return {
      'registro': registro,
      'descripcion' : descripcion,
      'tabla' : tabla,
      'parametro0' : parametro0,
      'parametro1' : parametro1,
      'parametro2' : parametro2,
      'parametro3' : parametro3,
    };
  }

}
