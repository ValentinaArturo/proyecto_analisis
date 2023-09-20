class SuccessResponse {
  final int status;
  final String msg;

  SuccessResponse({
    required this.status,
    required this.msg,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json) => SuccessResponse(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}
