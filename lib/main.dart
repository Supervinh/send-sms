import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobitag SMS',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController senderController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  static const int maxMessageLength = 160;
  int remainingChars = maxMessageLength;

  @override
  void initState() {
    super.initState();
    messageController.addListener(_updateRemainingChars);
  }

  void _updateRemainingChars() {
    setState(() {
      remainingChars = maxMessageLength - messageController.text.length;
      if (remainingChars < 0) remainingChars = 0;
    });
  }

  @override
  void dispose() {
    senderController.dispose();
    recipientController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    String sender = senderController.text.trim();
    String recipient = recipientController.text.trim();
    String message = messageController.text.trim();
    final apiKey = dotenv.env['OPTNC_MOBITAGNC_API_KEY'];

    if (sender.isNotEmpty && sender.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le numéro expéditeur doit contenir exactement 6 chiffres ou être vide.')),
      );
      return;
    }
    if (recipient.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le numéro destinataire doit contenir exactement 6 chiffres.')),
      );
      return;
    }

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le message est obligatoire.')),
      );
      return;
    }

    if (apiKey == null || apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clé API manquante.')),
      );
      return;
    }

    final url = Uri.parse('https://api.opt.nc/mobitag/sendSms');
    final response = await http.post(
      url,
      headers: {
        'x-apikey': $apiKey,
        'Content-Type': 'application/json',
      },
      body: '''{
        "from": "$sender",
        "to": "$recipient",
        "message": "$message"
      }''',
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message envoyé avec succès !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi : ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),
                  TextField(
                    controller: senderController,
                    decoration: InputDecoration(
                      labelText: 'Numéro expéditeur',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: recipientController,
                    decoration: InputDecoration(
                      labelText: 'Numéro destinataire *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: 'Message *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    maxLength: maxMessageLength,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: sendMessage,
                    child: Text('Envoyer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
