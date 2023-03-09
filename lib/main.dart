import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

FirebaseApp? firebaseApp;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Assignment - Group3',
      home: IntroPage(
        title: 'Welcome!',
      ),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({super.key, required this.title});
  final String title;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  TextEditingController nameController = TextEditingController();
  String name = '', tempName = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          image: AssetImage('images/background_image.jpeg'),
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.transparent,
            ),
            body: Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                      // autocorrect: false,
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Hey there! tell us how do we call you?',
                          hintText: 'Enter your name here'),
                      onChanged: (text) {
                        setState(() {
                          tempName = text;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          name = tempName;
                        });
                      },
                    ),
                  ),
                  if (name != '') UserChoiceList(name: name),
                ],
              ),
            )));
  }
}

class UserChoiceList extends StatefulWidget {
  const UserChoiceList({super.key, required this.name});
  final String name;
  @override
  State<UserChoiceList> createState() => _UserChoiceListState();
}

class _UserChoiceListState extends State<UserChoiceList> {
  String? instruction = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey! ${widget.name} what you want to do today?',
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const Divider(),
        RadioListTile(
          title: const Text(
            'Read thought of the day',
            style: TextStyle(fontSize: 20),
          ),
          value: 'QoD',
          // value: const Text('one'),
          groupValue: instruction,
          // onChanged: (value) {
          //   setState(() {
          //     instruction = value.toString();
          //   });
          // }
          onChanged: (value) {
            String quoteId = ((DateTime.now().day % 3) + 1).toString();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ThoughtOfDay(documentId: quoteId)),
            );
          },
        ),
        Text(instruction!),
        RadioListTile(
            title: const Text(
              'Show my surroundings',
              style: TextStyle(fontSize: 20),
            ),
            value: 'SMS',
            groupValue: instruction,
            onChanged: (value) {
              // if (kIsWeb) {
              //   js.context.callMethod('myFunction');
              // } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DisplaySurroundings()),
              );
              // }
            })
      ],
    );
  }
}

class ThoughtOfDay extends StatefulWidget {
  const ThoughtOfDay({super.key, required this.documentId});
  final String documentId;

  @override
  State<ThoughtOfDay> createState() => _ThoughtOfDayState();
}

class _ThoughtOfDayState extends State<ThoughtOfDay> {
  late Future<String> quote;
  Future<String> getQuote(String documentId) async {
    try {
      CollectionReference quotes =
          FirebaseFirestore.instance.collection("quotes");

      final snapshot = await quotes.doc(documentId).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['Thought'];
    } catch (e) {
      return 'Error fetching Thought of the day';
    }
  }

  @override
  void initState() {
    super.initState();
    quote = getQuote(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Thought of the day!'),
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.blue),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Container(
              color: const Color.fromARGB(255, 219, 244, 199),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Thought of the day:",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 30),
                  FutureBuilder<String>(
                      future: quote,
                      builder: (context, AsyncSnapshot<String> quoteString) {
                        if (quoteString.hasError) {
                          return const Text("Something Went Wrong");
                        }

                        if (quoteString.connectionState ==
                            ConnectionState.done) {
                          // Map<String, dynamic> data = quoteString;
                          quoteString.data!;
                          return Text(
                            quoteString.data!,
                            style: const TextStyle(fontSize: 20),
                          );
                        }
                        return const Text("Loading..");
                      })
                ],
              ))
        ]),
      ),
    );
  }
}

class DisplaySurroundings extends StatefulWidget {
  const DisplaySurroundings({super.key});

  @override
  State<DisplaySurroundings> createState() => _DisplaySurroundingsState();
}

class _DisplaySurroundingsState extends State<DisplaySurroundings> {
  // late GoogleMapController mapController;

  // final LatLng _center = const LatLng(18.564220, 73.787201);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return Text("Loading surroundings.....");
  }
}
