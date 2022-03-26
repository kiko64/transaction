class InsertarLectura {
  final int? id;  // dato requerido

  final int documento;
  final String direccion;
  final String adicional;
  final String municipio;

  final String medidor;
  final String anterior;
  final String? actual;
  final int? novedad;
  final String observacion;
  
  final int ejecucion;
  final int proceso;
  final String descripcion;

  InsertarLectura(
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
      });

  InsertarLectura.fromMap(Map<String, dynamic> lec)
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
        descripcion = lec["descripcion"];

  Map<String, Object?> toMap() {
    return {'id': id,
      'documento': documento, 'direccion': direccion, 'adicional': adicional, 'municipio': municipio,
      'medidor': medidor, 'anterior': anterior, 'actual' : actual,
      'novedad' : novedad, 'observacion' : observacion,
      'ejecucion' : ejecucion, 'proceso' : proceso, 'descripcion' : descripcion
    };
  }

}
