import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avis Produit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AvisProduitPage(),
    );
  }
}

class AvisProduitPage extends StatefulWidget {
  @override
  _AvisProduitPageState createState() => _AvisProduitPageState();
}

class _AvisProduitPageState extends State<AvisProduitPage> {
  final _formKey = GlobalKey<FormState>();
  String nomProduit = '';
  String commentaire = '';
  double note = 3.0;

  List<Map<String, dynamic>> avisList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donner votre avis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom du produit',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du produit';
                  }
                  return null;
                },
                onSaved: (value) {
                  nomProduit = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Commentaire',
                ),
                maxLength: 60,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un commentaire';
                  } else if (value.length < 20) {
                    return 'Le commentaire doit contenir au moins 20 caractères';
                  }
                  return null;
                },
                onSaved: (value) {
                  commentaire = value!;
                },
              ),
              SizedBox(height: 20),
              Text("Note:"),
              RatingBar.builder(
                initialRating: note,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    note = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        avisList.add({
                          'nomProduit': nomProduit,
                          'commentaire': commentaire,
                          'note': note,
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Merci pour avoir donné votre avis! Note: $note/5')),
                      );
                    }
                  },
                  child: Text('Soumettre'),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: avisList.isEmpty
                    ? Center(child: Text("Aucun avis n'a été enregistré."))
                    : ListView.builder(
                        itemCount: avisList.length,
                        itemBuilder: (context, index) {
                          final avis = avisList[index];
                          return ListTile(
                            title: Text(avis['nomProduit']),
                            subtitle: Text('${avis['commentaire']}\nNote: ${avis['note']}/5'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
