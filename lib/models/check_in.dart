enum CheckInStatus { ok, later, help }

extension CheckInStatusLabel on CheckInStatus {
  String get label {
    switch (this) {
      case CheckInStatus.ok:
        return 'Estou bem';
      case CheckInStatus.later:
        return 'Mais tarde';
      case CheckInStatus.help:
        return 'Pedi ajuda';
    }
  }
}

class CheckIn {
  const CheckIn({required this.time, required this.status});

  final DateTime time;
  final CheckInStatus status;

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'status': status.name,
    };
  }

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      time: DateTime.parse(json['time'] as String),
      status: CheckInStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => CheckInStatus.ok,
      ),
    );
  }
}
