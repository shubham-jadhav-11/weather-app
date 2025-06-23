import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  final String backgroundImage; // Path to the background image
  final String weatherIcon;

  WeatherWidget({
    required this.weather,
    required this.backgroundImage,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(backgroundImage), // Set the background image here
          fit: BoxFit.cover, // Cover the entire container
          colorFilter: ColorFilter.mode(
            Colors.blue.withOpacity(0.4), // Adjusted opacity for better contrast
            BlendMode.darken, // Darken the image for readability
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // City name
          Text(
            weather.cityName,
            style: GoogleFonts.lato(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black45,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Date
          Text(
            DateFormat('EEEE, d MMMM').format(DateTime.now()),
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.white70,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Weather icon from OpenWeatherMap
          Image.network(
            weatherIcon,
            scale: 1.5,
            color: Colors.white, // Add white tint to match the theme
            colorBlendMode: BlendMode.modulate,
          ),
          SizedBox(height: 20),
          // Temperature
          Text(
            '${weather.temperature.toStringAsFixed(1)}°C',
            style: GoogleFonts.lato(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black45,
                  offset: Offset(4, 4),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Weather description
          Text(
            weather.description.toUpperCase(),
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.white70,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black38,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Additional weather info (e.g., humidity, wind speed) - can be expanded upon as needed
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.water_drop, color: Colors.white70),
                  SizedBox(height: 5),
                  Text(
                    '${weather.humidity}%',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Humidity',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30),
              Column(
                children: [
                  Icon(Icons.air, color: Colors.white70),
                  SizedBox(height: 5),
                  Text(
                    '${weather.windSpeed} m/s',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Wind Speed',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
