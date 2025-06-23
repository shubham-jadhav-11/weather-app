class Weather {
  final double temperature;
  final String description;
  final String cityName;
  final String icon;
  final int humidity; // New field
  final double windSpeed; // New field

  Weather({
    required this.temperature,
    required this.description,
    required this.cityName,
    required this.icon,
    required this.humidity, // Initialize new field
    required this.windSpeed, // Initialize new field
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'],
      description: json['weather'][0]['description'],
      cityName: json['name'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'], // Assign new field
      windSpeed: json['wind']['speed'], // Assign new field
    );
  }
}
