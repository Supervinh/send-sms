import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
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
    if (apiKey == null || apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clé API manquante.')),
      );
      return;
    }
    // log apiKey for debugging purposes
    print('API Key HEHEHE: $apiKey');
    final url = Uri.parse('https://api.opt.nc/mobitag/sendSms');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
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
    // var appState = context.watch<MyAppState>();
    // var pair = appState.current;

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
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: recipientController,
                    decoration: InputDecoration(
                      labelText: 'Numéro destinataire',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
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

class RandomPair extends StatelessWidget {
  const RandomPair({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      // color: theme.colorScheme.primary,
      // red color with a theme
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}
