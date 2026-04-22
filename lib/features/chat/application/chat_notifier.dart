import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';

class ChatMessage {
  final String role; // 'user' | 'assistant'
  final String text;
  final String? imagePath;

  const ChatMessage({
    required this.role,
    required this.text,
    this.imagePath,
  });
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  static const _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-haiku-4-5-20251001';
  static const _system =
      'You are Planty, a friendly and knowledgeable plant care assistant. '
      'Help users with watering schedules, fertilizing, diagnosing plant problems, '
      'and identifying plants from photos. Keep answers concise and practical. '
      'If the user sends a photo, describe what you see and provide relevant care advice. '
      'Always respond in the same language the user writes in.';

  @override
  ChatState build() => const ChatState();

  Future<void> send(String text, {String? imagePath}) async {
    if (text.trim().isEmpty && imagePath == null) return;

    final userMsg = ChatMessage(role: 'user', text: text, imagePath: imagePath);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      final apiMessages = _buildApiMessages();
      final response = await _callApi(apiMessages);
      final assistantText = _extractText(response);

      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(role: 'assistant', text: assistantText),
        ],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  List<Map<String, dynamic>> _buildApiMessages() {
    return state.messages.map((msg) {
      if (msg.imagePath != null) {
        final bytes = File(msg.imagePath!).readAsBytesSync();
        final b64 = base64Encode(bytes);
        return {
          'role': msg.role,
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': 'image/jpeg',
                'data': b64,
              },
            },
            if (msg.text.isNotEmpty)
              {'type': 'text', 'text': msg.text},
          ],
        };
      }
      return {
        'role': msg.role,
        'content': msg.text,
      };
    }).toList();
  }

  Future<Map<String, dynamic>> _callApi(
      List<Map<String, dynamic>> messages) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'x-api-key': AppConfig.anthropicApiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 1024,
        'system': _system,
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  String _extractText(Map<String, dynamic> response) {
    final content = response['content'] as List<dynamic>? ?? [];
    for (final block in content) {
      if (block is Map && block['type'] == 'text') {
        return block['text'] as String? ?? '';
      }
    }
    return '';
  }
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
