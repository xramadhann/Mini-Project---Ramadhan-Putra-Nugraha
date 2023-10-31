import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];

  @override
  void initState() {
    super.initState();
    // Pesan selamat datang dari chat bot saat aplikasi pertama kali dimuat
    _addChatMessage(
        'Selamat datang di Chat Bot MySPBU! Saya bisa membantu dengan pertanyaan tentang BBM, SPBU, dan bahan bakar di Indonesia.',
        isBotResponse: true);
  }

  // Fungsi untuk menambahkan pesan ke daftar chat
  void _addChatMessage(String text, {bool isBotResponse = false}) {
    ChatMessage message = ChatMessage(text: text, isBotResponse: isBotResponse);
    setState(() {
      chatMessages.add(message);
    });
  }

  // Fungsi untuk mendapatkan respons dari chat bot
  Future<void> _getChatBotResponse(String query) async {
    _addChatMessage('Sedang mengetik...', isBotResponse: true);
    if (_isAllowedTopic(query)) {
      try {
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer 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',
          },
          body: jsonEncode({
            'model': 'text-davinci-003',
            'prompt': 'Pertanyaan: $query\nBot:',
            'max_tokens': 250,
            'temperature': 0.9,
            'top_p': 1,
          }),
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          String botResponse = data['choices'][0]['text'].trim();
          // Hapus pesan "Sedang mengetik..." dari daftar pesan
          chatMessages
              .removeWhere((message) => message.text == 'Sedang mengetik...');
          _addChatMessage(botResponse, isBotResponse: true);
        } else {
          _addChatMessage('Gagal mendapatkan respons.', isBotResponse: true);
        }
      } catch (error) {
        _addChatMessage('Error: $error', isBotResponse: true);
      }
    } else {
      // Jika pertanyaan berada di luar topik, beri pesan ini
      _addChatMessage('Mohon maaf, saya tidak menjawab pertanyaan Anda.',
          isBotResponse: true);
    }
  }

  bool _isAllowedTopic(String question) {
    return question.toLowerCase().contains('spbu') ||
        question.toLowerCase().contains('bbm') ||
        question.toLowerCase().contains('oktan') ||
        question.toLowerCase().contains('bensin') ||
        question.toLowerCase().contains('harga bensin') ||
        question.toLowerCase().contains('bahan bakar');
  }

  // Fungsi untuk menangani pengiriman pesan dari pengguna
  void _handleSubmittedMessage(String text) {
    if (text.isNotEmpty) {
      _addChatMessage('$text');
      _getChatBotResponse(text);
      messageController.clear();
    }
  }

  // Fungsi untuk menghapus semua pesan
  void _clearChat() {
    setState(() {
      chatMessages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Chat Bot',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: chatMessages[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onSubmitted: _handleSubmittedMessage,
                    decoration: InputDecoration(
                      labelText: 'Ketik pertanyaan Anda...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _handleSubmittedMessage(messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isBotResponse;

  ChatMessage({required this.text, this.isBotResponse = false});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: message.isBotResponse
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              message.isBotResponse ? 'Chat Bot MySPBU' : 'Anda',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isBotResponse ? Colors.grey[200] : Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                  color: message.isBotResponse ? Colors.black : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
