import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For time formatting
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import '../services/weather_service.dart';
import '../widgets/weather_widget.dart';
import '../models/forecast.dart'; // Import Forecast model

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _city = "Pune"; // Default city
  TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0; // For bottom navigation bar index
  List<String> _locations = ["Pune"]; // List to store locations

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location on startup
    _fetchWeatherByCity(_city); // Fetch weather for default city initially
    _fetchForecastByCity(_city); // Fetch forecast for default city initially
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request location permissions
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Fetch weather for the current location
        _fetchWeather(position);
      } else {
        // Handle permission denied
        print("Location permission denied");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _fetchWeather(Position position) {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    weatherService.fetchWeatherByCoordinates(position.latitude, position.longitude);
  }

  void _fetchWeatherByCity(String city) {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    weatherService.fetchWeather(city);
  }

  void _fetchForecastByCity(String city) {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    weatherService.fetchForecast(city);
  }

  void _onSearch() {
    String city = _searchController.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _city = city;
        if (!_locations.contains(city)) {
          _locations.add(city); // Add city to location list if not already present
        }
      });
      _fetchWeatherByCity(city);
      _fetchForecastByCity(city); // Fetch forecast as well
    }
  }

  Widget _buildWeatherScreen() {
    final weatherService = Provider.of<WeatherService>(context);
    final weather = weatherService.weatherData;

    if (weather == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return WeatherWidget(
      weather: weather,
      backgroundImage: 'assets/images/sunny.jpg', // Example background image
      weatherIcon: 'https://openweathermap.org/img/w/${weather.icon}.png', // Weather icon URL
    );
  }

  // Build the forecast screen widget
  Widget _buildForecastScreen() {
    final weatherService = Provider.of<WeatherService>(context);
    final forecastData = weatherService.forecastData;

    if (forecastData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        for (var forecast in forecastData)
          ListTile(
            leading: Image.network('https://openweathermap.org/img/w/${forecast.icon}.png'),
            title: Text(
              DateFormat('EEEE, d MMMM').format(forecast.dateTime), // Display the date
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              '${DateFormat('HH:mm').format(forecast.dateTime)} - ${forecast.description.toUpperCase()}', // Display time and description
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            trailing: Text(
              '${forecast.temperature.toStringAsFixed(1)}°C', // Temperature
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Saved Locations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        for (var location in _locations)
          ListTile(
            title: Text(location),
            onTap: () {
              setState(() {
                _city = location;
                _fetchWeatherByCity(location);
                _fetchForecastByCity(location);
              });
              Navigator.pop(context); // Close drawer
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Apply gradient background here
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A5ACD), // First color (top)
              Color(0xFF000080), // Second color (bottom)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _currentIndex == 0 ? _buildWeatherScreen() : _buildForecastScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                onSubmitted: (value) {
                  _onSearch();
                },
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF6A5ACD),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF000080),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(Icons.person, size: 45, color: Color(0xFF1F233B)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "User Name",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "user@example.com",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Switch to weather screen
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Forecast'),
              onTap: () {
                setState(() {
                  _currentIndex = 1; // Switch to Forecast screen
                  _fetchForecastByCity(_city); // Fetch forecast data when tapped
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            _buildLocationList(), // Location list is added here
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              // Fetch forecast when switching to forecast screen
              _fetchForecastByCity(_city);
            }
          });
        },
        backgroundColor: Color(0xFF000080),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
