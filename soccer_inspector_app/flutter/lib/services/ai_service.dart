import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {

  // URL DA IA NO RENDER
  static const String aiUrl =
      'https://soccerinspectoria.onrender.com';

  static Future<Map<String, dynamic>> gerarRelatorio({
    required int athleteId,
    required double distance,
    required double metresPerMinute,
    required double duration,
    required double highIntensityRunning,
    required double highIntensityEvents,
    required double sprintDistance,
    required double sprints,
    required double rawTopSpeed,
    required double topSpeed,
    required double avgSpeed,
    required double accelerations,
    required double decelerations,
    required double workload,
    required double workloadVolume,
    required double workloadIntensity,
  }) async {

    final response = await http.post(
      Uri.parse('$aiUrl/prever'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "athlete_id": athleteId,
        "distance": distance,
        "metres_per_minute": metresPerMinute,
        "duration": duration,
        "high_intensity_running": highIntensityRunning,
        "high_intensity_events": highIntensityEvents,
        "sprint_distance": sprintDistance,
        "sprints": sprints,
        "raw_top_speed": rawTopSpeed,
        "top_speed": topSpeed,
        "avg_speed": avgSpeed,
        "accelerations": accelerations,
        "decelerations": decelerations,
        "workload": workload,
        "workload_volume": workloadVolume,
        "workload_intensity": workloadIntensity,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Erro ao gerar relatório: ${response.body}'
    );
  }
}