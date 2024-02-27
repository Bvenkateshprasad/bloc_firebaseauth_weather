import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth_bloc_weather/auth/login_screen.dart';
import 'package:firebase_auth_bloc_weather/blocs/bloc/auth_bloc.dart';
import 'package:firebase_auth_bloc_weather/home/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/snackbar.dart';
import '../widgets/weather_widgets/additional_info_item.dart';
import '../widgets/weather_widgets/hourly_forecast_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=4af409a4c67493e64a7c44c96d9c51e3',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black38,
            title: Text(
                "Welcome : ${(state as AuthSuccess).uid.email.toString()}"),
            centerTitle: true,
            actions: [
              TextButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"))
            ],
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: FutureBuilder(
                  future: weather,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    final data = snapshot.data!;

                    final currentWeatherData = data['list'][0];
                    final currentTemp = currentWeatherData['main']['temp'];
                    final currentSky = currentWeatherData['weather'][0]['main'];
                    final currentPressure =
                        currentWeatherData['main']['pressure'];
                    final currentWindSpeed =
                        currentWeatherData['wind']['speed'];
                    final currentHumidity =
                        currentWeatherData['main']['humidity'];
                    final population = data['city']['population'];
                    final inDegree =
                        currentTemp - 273.15; //Kelvin to Celsius conversion
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // main card
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
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: TextButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (c) =>
                                                            const SearchScreen()));
                                              },
                                              icon: const Icon(Icons.search),
                                              label: const Text("Search")),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  '${inDegree.toStringAsFixed(2)} C',
                                                  style: const TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Icon(
                                                  currentSky == 'Clouds' ||
                                                          currentSky == 'Rain'
                                                      ? Icons.cloud
                                                      : Icons.sunny,
                                                  size: 64,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  currentSky,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Icon(
                                                  Icons.groups_2_outlined,
                                                  size: 64,
                                                ),
                                                Text(
                                                  "Population in $cityName : $population",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Hourly Forecast',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final hourlyForecast = data['list'][index + 1];
                                final hourlySky = data['list'][index + 1]
                                    ['weather'][0]['main'];
                                final hourlyTemp =
                                    hourlyForecast['main']['temp'].toString();
                                final time =
                                    DateTime.parse(hourlyForecast['dt_txt']);
                                return HourlyForecastItem(
                                  time: DateFormat.j().format(time),
                                  temperature: hourlyTemp,
                                  icon: hourlySky == 'Clouds' ||
                                          hourlySky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdditionalInfoItem(
                                icon: Icons.water_drop,
                                label: 'Humidity',
                                value: currentHumidity.toString(),
                              ),
                              AdditionalInfoItem(
                                icon: Icons.air,
                                label: 'Wind Speed',
                                value: currentWindSpeed.toString(),
                              ),
                              AdditionalInfoItem(
                                icon: Icons.beach_access,
                                label: 'Pressure',
                                value: currentPressure.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
