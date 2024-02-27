import 'package:firebase_auth_bloc_weather/home/home.dart';
import 'package:flutter/material.dart';

import '../widgets/snackbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                    label: Text("Showing Weather Of : $cityName")),
                onChanged: (val) {
                  setState(() {
                    cityName = val.toString();
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()),
                      (route) => false);
                },
                child: const Text("Search"))
          ],
        ),
      ),
    );
  }
}
