class Lectura {
  late int? id;  // dato requerido

  late  int documento;
  late  String direccion;
  late  String adicional;
  late  String municipio;

  late  String medidor;
  late  String anterior;
  late  String? actual;
  late  int? novedad;
  late  String observacion;
  
  late  int ejecucion;
  late  int proceso;
  late  String descripcion;
  late  String descripcionregistro;

  Lectura(
      { this.id,
        required this.documento,
        required this.direccion,
        required this.adicional,
        required this.municipio,

        required this.medidor,
        required this.anterior,
        this.actual,
        this.novedad,
        required this.observacion,
        
        required this.ejecucion,
        required this.proceso,
        required this.descripcion,
        required this.descripcionregistro,
      });

  Lectura.fromMap(Map<String, dynamic> lec)
      : id = lec["id"],

        documento = lec["documento"],
        direccion = lec["direccion"],
        adicional = lec["adicional"],
        municipio = lec["municipio"],

        medidor = lec["medidor"],
        anterior = lec["anterior"],
        actual = lec["actual"],
        novedad = lec["novedad"],
        observacion = lec["observacion"],
        ejecucion = lec["ejecucion"],
        proceso = lec["proceso"],
        descripcion = lec["descripcion"],
        descripcionregistro = lec["descripcionregistro"];

  Map<String, Object?> toMap() {
    return {'id': id,
      'documento': documento, 'direccion': direccion, 'adicional': adicional, 'municipio': municipio,
      'medidor': medidor, 'anterior': anterior, 'actual' : actual,
      'novedad' : novedad, 'observacion' : observacion,
      'ejecucion' : ejecucion, 'proceso' : proceso, 'descripcion' : descripcion,
      'descripcionregistro' : descripcionregistro
    };
  }

}
