class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.favorite = false,
  });

  final String id;
  final String name;
  final String relation;
  final String phone;
  final bool favorite;

  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Contact copyWith({bool? favorite}) {
    return Contact(
      id: id,
      name: name,
      relation: relation,
      phone: phone,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'phone': phone,
      'favorite': favorite,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      relation: json['relation'] as String,
      phone: json['phone'] as String,
      favorite: json['favorite'] as bool? ?? false,
    );
  }

  static const List<Contact> samples = [
    Contact(
      id: '1',
      name: 'Maria Souza',
      relation: 'Filha',
      phone: '11900000001',
      favorite: true,
    ),
    Contact(
      id: '2',
      name: 'João Souza',
      relation: 'Filho',
      phone: '11900000002',
      favorite: true,
    ),
    Contact(
      id: '3',
      name: 'Ana Lima',
      relation: 'Vizinha',
      phone: '11900000003',
    ),
    Contact(
      id: '4',
      name: 'Dr. Carlos',
      relation: 'Médico',
      phone: '11900000004',
    ),
  ];
}
