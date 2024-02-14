import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/audio_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class DeezerPage extends StatefulWidget {
  const DeezerPage({Key? key}) : super(key: key);

  @override
  State<DeezerPage> createState() => _DeezerPageState();
}

class _DeezerPageState extends State<DeezerPage> {
  final AudioController audioController = Get.put(AudioController());
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deezer"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for songs...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchSongs(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var result = _searchResults[index];
                      return ListTile(
                        title: Text(result['title']),
                        subtitle: Text(result['artist']['name']),
                        onTap: () {
                          String link = result["preview"];
                          audioController.playSongFromDeezer(link);
                          
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchSongs(String query) async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(
      Uri.parse('https://api.deezer.com/search?q=$query'),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        _searchResults = jsonResponse['data'];
        _loading = false;
      });
    } else {
      setState(() {
        _searchResults = [];
        _loading = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
