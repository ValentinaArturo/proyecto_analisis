class PersonResponse {
  final List<Person> users;

  PersonResponse({
    required this.users,
  });

  factory PersonResponse.fromJson(List<dynamic> json) => PersonResponse(
          users: List.from(
        (json).map(
          (user) => Person.fromJson(
            user,
          ),
        ),
      ));
}

class Person {
  final String idPersona;
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final String idGenero;
  final String direccion;
  final String telefono;
  final String correoElectronico;
  final String idEstadoCivil;
  final String fechaCreacion;
  final String usuarioCreacion;
  final String? fechaModificacion;
  final String? usuarioModificacion;

  Person({
    required this.idPersona,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.idGenero,
    required this.direccion,
    required this.telefono,
    required this.correoElectronico,
    required this.idEstadoCivil,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      idPersona: json['IdPersona'],
      nombre: json['Nombre'],
      apellido: json['Apellido'],
      fechaNacimiento: json['FechaNacimiento'],
      idGenero: json['IdGenero'],
      direccion: json['Direccion'],
      telefono: json['Telefono'],
      correoElectronico: json['CorreoElectronico'],
      idEstadoCivil: json['IdEstadoCivil'],
      fechaCreacion: json['FechaCreacion'],
      usuarioCreacion: json['UsuarioCreacion'],
      fechaModificacion: json['FechaModificacion'],
      usuarioModificacion: json['UsuarioModificacion'],
    );
  }
}
