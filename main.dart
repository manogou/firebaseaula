import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void adicionarUsuario() {
    FirebaseFirestore.instance.collection('usuarios').add({ //.doc('patrick').set  define o nome do decumento
      'nome': 'Patrick',
      'idade': 21,
      'cidade': 'Campo Verde',
      'timestamp': FieldValue.serverTimestamp()
    });
    FirebaseFirestore.instance.collection('usuarios').doc('gabriel').set({
      'nome': 'Gabriel',
      'idade': 'todos',
      'cidade': 'sim',
      'Hora adição': FieldValue.serverTimestamp()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exemplo Firestore"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarUsuario,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final documentos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documentos.length,
            itemBuilder: (context, index) {

              final dados = documentos[index];

              return ListTile(
                title: Text(dados['nome']),
                subtitle: Text(
                  "Idade: ${dados['idade']} - Cidade: ${dados['cidade']}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}