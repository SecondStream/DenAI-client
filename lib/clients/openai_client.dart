import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:den_ai/common/exceptions.dart';
import 'package:den_ai/models/model_info.dart';
import 'package:den_ai/models/settings_base.dart';
import 'package:dio/dio.dart';

class OpenAIClient {
  static const String urlChat = "/chat/completions";
  static const String urlModels = "/models";
  static const String urlEmbeddings = "/embeddings";
  final String defaultModel;
  final String defaultVisionModel;
  final String defaultEmbeddingModel;

  final Dio dio;
  List<dynamic>? cachedModelsList;

  OpenAIClient({
    required this.defaultModel,
    required this.defaultVisionModel,
    required this.defaultEmbeddingModel,

    required this.dio,
  });

  Map<String, String> _getHeaders(String key) {
    return {
      "Authorization": "Bearer $key",
      "Content-Type": "application/json",
      "HTTP-Referer": "http://localhost:3000",
      "X-Title": "DenAI",
    };
  }

  Stream<String> sendMessage({
    required SettingsBase settings,
    required List<Map<String, String>> messages,
  }) async* {
    final Map<String, dynamic> payload = _getPayload(settings, messages);

    print('PAYLOAD: $payload');

    const int maxRetries = 1;
    final random = Random();

    double retryDelaySeconds = 25.0 + random.nextDouble();
    String allTokens = "";

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await dio.post<ResponseBody>(
          '${settings.provider.url.replaceAll(RegExp(r'/$'), '')}$urlChat',
          data: payload,
          options: Options(
            headers: _getHeaders(settings.provider.key),
            responseType: ResponseType.stream,
          ),
        );

        if (response.statusCode != 200) {
          throw Exception("OpenRouter error ${response.statusCode}");
        }

        final Stream<String> lineStream = response.data!.stream
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        await for (final line in lineStream) {
          try {
            if (line.isNotEmpty && line.startsWith("data: ")) {
              final String lineContent = line.substring(6).trim();
              if (lineContent == "[DONE]") break;

              final chunk = jsonDecode(lineContent) as Map<String, dynamic>;

              if (chunk.containsKey("error")) {
                final errorObj = chunk["error"] as Map<String, dynamic>;
                final String errMsg = errorObj["message"] ?? "Unknown upstream error";
                throw LLMProviderException("Provider LLM Error: $errMsg");
              }

              final choices = chunk["choices"] as List<dynamic>? ?? const [];
              if (choices.isEmpty) continue;

              final delta = choices.first["delta"] as Map<String, dynamic>? ?? const {};
              final String token = delta["content"] as String? ?? "";

              if (token.isNotEmpty) {
                allTokens += token;
                yield token;
              }
            } else if (line.trim().startsWith("{")) {
              final errorJson = jsonDecode(line.trim()) as Map<String, dynamic>;
              final errorData = errorJson["error"] ?? errorJson["data"]?["error"];
              if (errorData != null) {
                final message = errorData is Map
                    ? (errorData["message"] ?? "Unknown LLM error")
                    : errorData.toString();
                throw LLMProviderException("Provider LLM Error: $message");
              }
            }
          } catch (e) {
            // rethrow only provider exception
            if (e is LLMProviderException) {
              rethrow;
            }
            continue;
          }
        }
        return;
      } catch (e) {
        if (attempt >= maxRetries) {
          throw Exception("Provider unaviable.");
        }

        if (allTokens.isNotEmpty) {
          allTokens = allTokens.replaceFirst(RegExp(r'\s[^\s\d\w]*\w+$'), ' ');

          final List<dynamic> msgs = payload["messages"] as List<dynamic>? ?? [];
          if (msgs.isNotEmpty) {
            final Map<String, dynamic> last = msgs.last as Map<String, dynamic>;
            if (last["role"] == "user") {
              msgs.add({"role": "assistant", "content": allTokens});
            } else if (last["role"] == "assistant") {
              last["content"] = allTokens;
            }
          }
        }

        await Future.delayed(Duration(milliseconds: (retryDelaySeconds * 1000).toInt()));
        retryDelaySeconds += 5.0 + random.nextDouble();
      }
    }
  }

  Future<List<List<double>>> getEmbeddings({
    required List<String> texts,
    required SettingsBase settings,
  }) async {
    if (texts.isEmpty) return const [];

    try {
      final response = await dio.post(
        '${settings.provider.url.replaceAll(RegExp(r'/$'), '')}$urlEmbeddings',
        options: Options(headers: _getHeaders(settings.provider.key)),
        data: {'model': settings.embeddingModelName, 'input': texts},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final dataList = data['data'] as List<dynamic>;

        final List<List<double>> result = [];
        if (dataList.length != texts.length) throw Error();
        for (final item in dataList) {
          if (item is Map<String, dynamic>) {
            final embeddingList = item['embedding'] as List<dynamic>;
            result.add(embeddingList.map((e) => double.tryParse(e.toString()) ?? 0.0).toList());
          }
        }
        return result;
      }
    } catch (e) {
      rethrow;
    }

    throw Error();
  }

  Future<String> describeImage({
    required String base64Image,
    required String prompt,
    required SettingsBase settings,
  }) async {
    try {
      final response = await dio.post(
        '${settings.provider.url.replaceAll(RegExp(r'/$'), '')}$urlChat',
        options: Options(headers: _getHeaders(settings.provider.key)),
        data: {
          'model': settings.visionModelName,
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': prompt},
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
              ],
            },
          ],
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          final firstChoice = choices.first as Map<String, dynamic>;
          final message = firstChoice['message'] as Map<String, dynamic>;
          return (message['content'] as String? ?? '').trim();
        }
      }
      // ignore: empty_catches
    } catch (e) {}
    return '';
  }

  Future<List<dynamic>> _getRemoteModels(SettingsBase settings) async {
    final String openrouterUrl = '${settings.provider.url.replaceAll(RegExp(r'/$'), '')}$urlModels';

    try {
      final response = await dio.get(
        openrouterUrl,
        options: Options(
          headers: _getHeaders(settings.provider.key),
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return data["data"] as List<dynamic>? ?? const [];
      } else {
        throw Exception("Provider error ${response.statusCode}: ${response.data}");
      }
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() => cachedModelsList = null;

  Future<Set<String>> fetchAllModelNames(SettingsBase settings) async {
    if (cachedModelsList == null || cachedModelsList!.isEmpty) {
      cachedModelsList = await _getRemoteModels(settings);
    }

    final Set<String> result = {};
    for (final m in cachedModelsList!) {
      if (m is! Map<String, dynamic>) continue;
      final String? name = m["id"] as String?;
      if (name == null || name.isEmpty) continue;
      result.add(name);
    }
    return result;
  }

  Future<List<ModelInfo>> fetchModels(SettingsBase settings, {bool vision = false}) async {
    try {
      if (cachedModelsList == null || cachedModelsList!.isEmpty) {
        cachedModelsList = await _getRemoteModels(settings);
      }

      final List<ModelInfo> result = <ModelInfo>[];

      for (final m in cachedModelsList!) {
        if (m is! Map<String, dynamic>) continue;

        final String? name = m["id"] as String?;
        if (name == null || name.isEmpty) continue;

        if (vision) {
          final Map<String, dynamic>? architecture = m["architecture"] as Map<String, dynamic>?;
          if (architecture != null) {
            final String modality = architecture["modality"] as String? ?? "";
            final String inputModality = modality.split("->").first;
            if (!inputModality.contains("image")) {
              continue;
            }
          }
        }

        final int contextLength = m["context_length"] as int? ?? 0;
        final Map<String, dynamic>? pricing = m["pricing"] as Map<String, dynamic>?;

        if (pricing == null) {
          final String ctxStr = contextLength > 0 ? "${contextLength ~/ 1024}k ctx" : "?k ctx";
          result.add(ModelInfo(name: name, info: "API | $ctxStr"));
          continue;
        }

        final double promptCost = double.tryParse(pricing["prompt"]?.toString() ?? "0") ?? 0.0;
        final double promptCostPerMillion = promptCost * 1000000;
        if (promptCostPerMillion < 0.0) continue;

        final double completionCost =
            double.tryParse(pricing["completion"]?.toString() ?? "0") ?? 0.0;
        final double completionCostPerMillion = completionCost * 1000000;

        String infoStr = "??";
        if (promptCostPerMillion == 0 && completionCostPerMillion == 0 && contextLength > 0) {
          infoStr = "FREE | ${contextLength ~/ 1024}k ctx";
        } else if (contextLength > 0) {
          infoStr =
              "\$${promptCostPerMillion.toStringAsFixed(1)}/\$${completionCostPerMillion.toStringAsFixed(1)} M | ${contextLength ~/ 1024}k ctx";
        } else {
          infoStr =
              "\$${promptCostPerMillion.toStringAsFixed(1)}/\$${completionCostPerMillion.toStringAsFixed(1)} M";
        }

        result.add(ModelInfo(name: name, info: infoStr));
      }

      result.sort((a, b) => a.name.compareTo(b.name));

      return result;
      // ignore: empty_catches
    } catch (e) {}

    return [ModelInfo(name: !vision ? defaultModel : defaultVisionModel, info: "???")];
  }

  Future<List<ModelInfo>> fetchVisionModels(SettingsBase settings) async {
    return await fetchModels(settings, vision: true);
  }

  Future<List<ModelInfo>> fetchEmbeddingModels(SettingsBase settings) async {
    try {
      if (cachedModelsList == null || cachedModelsList!.isEmpty) {
        cachedModelsList = await _getRemoteModels(settings);
      }

      final List<ModelInfo> result = <ModelInfo>[];

      for (final m in cachedModelsList!) {
        if (m is! Map<String, dynamic>) continue;

        final String? name = m["id"] as String?;
        if (name == null || name.isEmpty) continue;

        bool isEmbedding = false;

        final Map<String, dynamic>? architecture = m["architecture"] as Map<String, dynamic>?;
        if (architecture != null) {
          final String modality = architecture["modality"] as String? ?? "";
          if (modality.endsWith("->embedding") || modality.contains("embedding")) {
            isEmbedding = true;
          }
        } else {
          isEmbedding = true;
        }

        if (!isEmbedding) continue;

        final int contextLength = m["context_length"] as int? ?? 0;
        final Map<String, dynamic>? pricing = m["pricing"] as Map<String, dynamic>?;

        if (pricing == null) {
          final String ctxStr = contextLength > 0 ? "${contextLength ~/ 1024}k ctx" : "?k ctx";
          result.add(ModelInfo(name: name, info: "API | $ctxStr"));
          continue;
        }

        final double promptCost = double.tryParse(pricing["prompt"]?.toString() ?? "0") ?? 0.0;
        final double promptCostPerMillion = promptCost * 1000000;
        if (promptCostPerMillion < 0.0) continue;

        final double completionCost =
            double.tryParse(pricing["completion"]?.toString() ?? "0") ?? 0.0;
        final double completionCostPerMillion = completionCost * 1000000;

        String infoStr = "??";
        if (promptCostPerMillion == 0 && completionCostPerMillion == 0 && contextLength > 0) {
          infoStr = "FREE | ${contextLength ~/ 1024}k ctx";
        } else if (contextLength > 0) {
          infoStr =
              "\$${promptCostPerMillion.toStringAsFixed(1)} M | ${contextLength ~/ 1024}k ctx";
        } else {
          infoStr = "\$${promptCostPerMillion.toStringAsFixed(1)} M";
        }

        result.add(ModelInfo(name: name, info: infoStr));
      }

      result.sort((a, b) {
        final int compInfo = a.info.compareTo(b.info);
        if (compInfo != 0) return compInfo;
        return a.name.compareTo(b.name);
      });

      return result;

      // ignore: empty_catches
    } catch (e) {}

    return [ModelInfo(name: defaultEmbeddingModel, info: "? ctx")];
  }

  Map<String, dynamic> _getPayload(SettingsBase settings, List<Map<String, String>> messages) {
    final basePayload = {
      "model": settings.modelName,
      "messages": messages,
      "stream": true,
      "temperature": double.parse(settings.temperature.toStringAsFixed(2)),
      "top_p": double.parse(settings.topP.toStringAsFixed(2)),
      "min_p": double.parse(settings.minP.toStringAsFixed(2)),
      "frequency_penalty": double.parse((settings.repeatPenalty - 1.0).toStringAsFixed(2)),
    };

    final String extraJson = settings.provider.additionalArgs.trim();
    if (extraJson.isNotEmpty) {
      try {
        final extraParams = jsonDecode(extraJson) as Map<String, dynamic>;
        return {...basePayload, ...extraParams};
      } catch (_) {}
    }
    return basePayload;
  }
}
