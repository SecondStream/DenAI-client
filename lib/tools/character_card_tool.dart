import 'dart:convert';
import 'dart:typed_data';
import 'package:den_ai/models/character_card.dart';
import 'package:png_chunks_extract/png_chunks_extract.dart' as extract;
import 'package:png_chunks_encode/png_chunks_encode.dart' as encode;
import 'package:png_chunk_text/png_chunk_text.dart' as chunk_text;

import '../models/char.dart';

abstract class CharacterCardTool {
  static Future<({Map<String, dynamic> cardJson, Uint8List? cardPng})> exportCard({
    required Char character,
    Uint8List? avatarBytes,
    String userNickname = 'LocalUser',
  }) async {
    Map<String, dynamic>? characterBook;

    if (character.lorebooks.isNotEmpty) {
      for (final lorebook in character.lorebooks) {
        if (lorebook.entries.isNotEmpty) {
          final List<Map<String, dynamic>> entriesList = [];

          for (var i = 0; i < lorebook.entries.length; i++) {
            final entry = lorebook.entries[i];
            entriesList.add({
              "id": i,
              "keys": [entry.title.toLowerCase()],
              "name": entry.title,
              "content": entry.content,
              "extensions": {},
              "enabled": true,
              "insertion_order": 100,
              "case_sensitive": false,
              "priority": 10,
              "comment": "",
              "selective": false,
              "secondary_keys": [],
              "constant": false,
              "position": "before_char",
            });
          }

          characterBook = {
            "name": lorebook.name,
            "description": lorebook.about,
            "scan_depth": 50,
            "token_budget": 500,
            "recursive_scanning": false,
            "extensions": {},
            "entries": entriesList,
          };
          break;
        }
      }
    }

    final Map<String, dynamic> cardV2 = {
      "spec": "chara_card_v2",
      "spec_version": "2.0",
      "data": {
        "name": character.name,
        "description": character.appearance,
        "personality": character.personality,
        "scenario": character.scenario,
        "first_mes": character.greeting,
        "mes_example": "",
        "creator_notes": "",
        "system_prompt": character.prompt,
        "post_history_instructions": "",
        "alternate_greetings": [],
        "tags": [],
        "creator": userNickname,
        "character_version": "1.0",
        "extensions": {},
      },
    };

    if (characterBook != null) {
      cardV2["data"]["character_book"] = characterBook;
    }

    Uint8List? finalPngBytes;

    if (avatarBytes != null && avatarBytes.isNotEmpty) {
      try {
        final chunks = extract.extractChunks(avatarBytes);
        final jsonString = jsonEncode(cardV2);
        final base64Str = base64Encode(utf8.encode(jsonString));
        final charaChunk = chunk_text.encode('chara', base64Str);

        chunks.insert(1, charaChunk);
        finalPngBytes = Uint8List.fromList(encode.encodeChunks(chunks));
        // ignore: empty_catches
      } catch (e) {}
    }

    return (cardJson: cardV2, cardPng: finalPngBytes);
  }

  static ImportedCardData? importCardFromPng(Uint8List pngBytes) {
    try {
      final chunks = extract.extractChunks(pngBytes);
      final textChunks = chunks.where((chunk) => chunk['name'] == 'tEXt');

      for (final chunk in textChunks) {
        final decodedChunk = chunk_text.decode(chunk['data']);
        if (decodedChunk['keyword'] == 'chara') {
          final base64Data = decodedChunk['text']!;
          final jsonString = utf8.decode(base64Decode(base64Data));
          final Map<String, dynamic> cardJson = jsonDecode(jsonString);
          final data = cardJson['data'] as Map<String, dynamic>? ?? cardJson;

          final List<ImportedLorebookData> importedLorebooks = [];
          final charBook = data['character_book'] as Map<String, dynamic>?;

          if (charBook != null) {
            final entriesJson = charBook['entries'] as List<dynamic>? ?? [];
            final List<ImportedLoreEntryData> importedEntries = [];

            for (final entry in entriesJson) {
              if (entry is Map<String, dynamic>) {
                importedEntries.add(
                  ImportedLoreEntryData(
                    title: entry['name'] ?? entry['keys']?.firstOrNull ?? '',
                    content: entry['content'] ?? '',
                  ),
                );
              }
            }

            importedLorebooks.add(
              ImportedLorebookData(
                name: charBook['name'] ?? 'Локальный лорбук',
                description: charBook['description'] ?? '',
                entries: importedEntries,
              ),
            );
          }

          return ImportedCardData(
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            personality: data['personality'] ?? '',
            scenario: data['scenario'] ?? '',
            greeting: data['first_mes'] ?? '',
            definition: data['creator_notes'] ?? '',
            instructions: data['system_prompt'] ?? '',
            tags: List<String>.from(data['tags'] ?? []),
            lorebooks: importedLorebooks,
          );
        }
      }
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }
}
