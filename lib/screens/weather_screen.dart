import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/additional_info_item.dart';
import 'package:weather_app/widgets/current_address.dart';
import 'package:weather_app/widgets/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  String cityName = "Loading...";

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // Get current location
      final Position position = await getUserLocation();

      // Get city name
      final Geocoding geocoding = Geocoding();

      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;

      if (mounted) {
        setState(() {
          cityName =
              '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
        });
      }

      // Get weather using latitude + longitude
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast'
          '?lat=${position.latitude}'
          '&lon=${position.longitude}'
          '&appid=$openWeatherAPIKey'
          '&units=metric',
        ),
      );

      final data = jsonDecode(result.body);

      if (data['cod'].toString() != '200') {
        throw data['message'] ?? 'Weather API error';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 5),
            Text(
              cityName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp °C",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Icon(getWeatherIcon(currentSky), size: 60),
                              const SizedBox(height: 14),
                              Text(currentSky, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Hourly Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky = hourlyForecast['weather'][0]['main'];
                      final hourlyTemp = hourlyForecast['main']['temp'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        icon: getWeatherIcon(hourlySky),
                        temperature: "${hourlyTemp.toStringAsFixed(1)}°C",
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  "Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: (Icons.water_drop),
                        label: "Humidity",
                        value: "$currentHumidity%",
                      ),
                      AdditionalInfoItem(
                        icon: (Icons.air),
                        label: "Wind Speed",
                        value: "${currentWindSpeed.toStringAsFixed(1)} m/s",
                      ),
                      AdditionalInfoItem(
                        icon: (Icons.speed),
                        label: "Pressure",
                        value: '$currentPressure hPa',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

IconData getWeatherIcon(String weather) {
  switch (weather) {
    case 'Clouds':
      return Icons.cloud;
    case 'Rain':
      return Icons.cloudy_snowing;
    case 'Thunderstorm':
      return Icons.thunderstorm;
    case 'Snow':
      return Icons.ac_unit;
    case 'Clear':
      return Icons.wb_sunny;
    default:
      return Icons.cloud;
  }
}

// SizedBox(
//   height: 120,
//   child: SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       children: [
//         for (int i = 0; i < 5; i++)
//           HourlyForecastItem(
//             time: data['list'][i + 1]['dt_txt'].toString(),
//             icon:
//                 data['list'][i + 1]['weather'][0]['main'] ==
//                         'Clouds' ||
//                     data['list'][i + 1]['weather'][0]['main'] ==
//                         'Rain'
//                 ? Icons.cloud
//                 : Icons.sunny,
//             temperature: data['list'][i + 1]['main']['temp']
//                 .toString(),
//           ),
//       ],
//     ),
//   ),
// ),
