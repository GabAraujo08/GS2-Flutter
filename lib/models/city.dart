class City {
  const City({
    required this.name,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String state;
  final double latitude;
  final double longitude;

  String get label => '$name - $state';

  static const List<City> capitals = [
    City(name: 'São Paulo', state: 'SP', latitude: -23.5505, longitude: -46.6333),
    City(name: 'Rio de Janeiro', state: 'RJ', latitude: -22.9068, longitude: -43.1729),
    City(name: 'Brasília', state: 'DF', latitude: -15.7939, longitude: -47.8828),
    City(name: 'Salvador', state: 'BA', latitude: -12.9777, longitude: -38.5016),
    City(name: 'Fortaleza', state: 'CE', latitude: -3.7319, longitude: -38.5267),
    City(name: 'Belo Horizonte', state: 'MG', latitude: -19.9167, longitude: -43.9345),
    City(name: 'Manaus', state: 'AM', latitude: -3.1190, longitude: -60.0217),
    City(name: 'Curitiba', state: 'PR', latitude: -25.4284, longitude: -49.2733),
    City(name: 'Recife', state: 'PE', latitude: -8.0476, longitude: -34.8770),
    City(name: 'Porto Alegre', state: 'RS', latitude: -30.0346, longitude: -51.2177),
  ];
}
