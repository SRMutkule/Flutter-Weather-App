# 🌤️ Flutter Weather App

A modern and responsive **Weather App built with Flutter** that provides real-time weather information using the **OpenWeather API**. The app can detect the user's current location and display weather information such as temperature, humidity, wind speed, pressure, and hourly forecasts.

## 📱 Features

* 🌡️ Real-time temperature information
* 📍 Current location-based weather
* 🌤️ Current weather condition
* 💧 Humidity information
* 💨 Wind speed
* 🌡️ Atmospheric pressure
* 🕐 Hourly weather forecast
* 🔄 Refresh weather data
* 📱 Responsive Flutter UI
* 🌎 Location detection using GPS
* 🔎 Reverse geocoding to display location name
* 🌐 OpenWeather API integration

## 🛠️ Technologies Used

* **Flutter**
* **Dart**
* **OpenWeather API**
* **HTTP Package**
* **Geolocator**
* **Geocoding**
* **Intl**

## 📦 Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.0.0
  geolocator: ^13.0.2
  geocoding: ^5.0.0
  intl: ^0.19.0
```

> Package versions may differ depending on your `pubspec.yaml`.

## 🔑 API

This application uses the **OpenWeather API** to retrieve weather information.

You need to create an API key from OpenWeather and add it to your project.

Example:

```dart
const String apiKey = "YOUR_API_KEY";
```

⚠️ **Do not upload your actual API key to GitHub.** Use a local secrets file or environment configuration and add it to `.gitignore`.

## 📍 Location Permission

The app uses the device's GPS location to retrieve weather information for the user's current location.

### Android

Add the following permissions to:

`android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

### 2. Open the Project

```bash
cd weather_app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Add Your API Key

Configure your OpenWeather API key in your local secrets/configuration file.

### 5. Run the Application

```bash
flutter run
```

## 📂 Project Structure

```text
lib/
│
├── main.dart
│
├── screens/
│   └── weather_screen.dart
│
├── widgets/
│   ├── additional_info_item.dart
|   └── current_address.dart
│   └── hourly_forecast_item.dart
│
└── secrets.dart
```

## 🌐 API Endpoint

The application uses OpenWeather's forecast API to retrieve weather information.

```text
https://api.openweathermap.org/data/2.5/forecast
```

Weather data includes:

* Temperature
* Weather condition
* Humidity
* Wind speed
* Atmospheric pressure
* Hourly forecast

## 🎯 Learning Objectives

This project helped me practice:

* Flutter UI development
* Dart programming
* REST API integration
* JSON data handling
* Asynchronous programming
* GPS location services
* Reverse geocoding
* State management using `StatefulWidget`
* Working with external Flutter packages
* Building responsive mobile interfaces

## 🔮 Future Improvements

* 🌙 Dark mode
* 🔍 Search weather by city
* ⭐ Favorite locations
* 📅 7-day weather forecast
* 🔔 Weather notifications
* 💾 Offline weather data
* 🎨 Improved weather animations

## 👨‍💻 Author

**Shubham Mutkule**

Flutter Developer | Java | Spring Boot | Mobile App Development

## ⭐ Support

If you found this project useful, consider giving it a ⭐ on GitHub.
