class DepartmentResponse {
  final List<Department> departments;

  DepartmentResponse({
    required this.departments,
  });

  factory DepartmentResponse.fromJson(List<dynamic> json) {
    return DepartmentResponse(
      departments: List<Department>.from(
        json.map((department) => Department.fromJson(department)),
      ),
    );
  }
}

class Department {
  final String idDepartamento;
  final String nombre;
  final String idEmpresa;
  final String fechaCreacion;
  final String usuarioCreacion;
  final String? fechaModificacion;
  final String? usuarioModificacion;

  Department({
    required this.idDepartamento,
    required this.nombre,
    required this.idEmpresa,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      idDepartamento: json['IdDepartamento'],
      nombre: json['Nombre'],
      idEmpresa: json['IdEmpresa'],
      fechaCreacion: json['FechaCreacion'],
      usuarioCreacion: json['UsuarioCreacion'],
      fechaModificacion: json['FechaModificacion'],
      usuarioModificacion: json['UsuarioModificacion'],
    );
  }
}
