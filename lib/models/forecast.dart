class Forecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon; // Ensure that the 'icon' field is defined

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon, // Include the 'icon' field in the constructor
  });

  // Factory method to create a Forecast object from JSON data
  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000), // Assuming 'dt' is a timestamp
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'], // Fetch the icon from weather data
    );
  }
}
