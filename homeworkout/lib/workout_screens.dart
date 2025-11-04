// workout_screens.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

// --- DATA MODEL ---

class Exercise {
  final String name;
  final String imageUrl;

  Exercise({
    required this.name,
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? 'No Name Provided',
      // Menggunakan 'gifUrl' sesuai dengan respons API yang diperbarui
      imageUrl: json['gifUrl'] ?? '',
    );
  }
}

// --- WIDGETS ---

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  late Future<List<Exercise>> futureExercises;

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises();
  }

  // Fungsi untuk mengambil data latihan dari API
  Future<List<Exercise>> fetchExercises() async {
    // URL endpoint API
    final url = Uri.parse('https://exercisedb.p.rapidapi.com/exercises');

    // Header yang diperlukan untuk otentikasi API
    final response = await http.get(
      url,
      headers: {
        'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
        // Ganti dengan API Key Anda
        'x-rapidapi-key': 'd1a2246798msha9a9a453db32de7p176e65jsn5e5ee63f33a6',
      },
    );

    if (response.statusCode == 200) {
      // Jika berhasil, parse JSON
      List<dynamic> exercisesList = json.decode(response.body);
      return exercisesList
          .map((exercise) => Exercise.fromJson(exercise))
          .toList();
    } else {
      // Jika gagal, lemparkan exception
      throw Exception(
          'Gagal memuat latihan. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strength Exercises'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: FutureBuilder<List<Exercise>>(
          future: futureExercises,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Tidak ada latihan yang ditemukan.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final exercise = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: exercise.imageUrl,
                            httpHeaders: const {
                              'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
                            },
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child:
                              CircularProgressIndicator(strokeWidth: 2.0),
                            ),
                            errorWidget: (context, url, error) {
                              print('CachedNetworkImage Error: $error');
                              return const Icon(Icons.error,
                                  color: Colors.grey);
                            },
                          ),
                        ),
                      ),
                      title: Text(exercise.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseDetailScreen(exercise: exercise),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({Key? key, required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (exercise.imageUrl.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    exercise.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 100, color: Colors.grey);
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              exercise.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}