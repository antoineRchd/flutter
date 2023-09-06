import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';

class ListPersonne extends StatefulWidget {
  const ListPersonne({super.key});

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseHelper().cloud_users.snapshots(),
        builder: (context, snap) {
          if (snap.data == null) {
            return Center(
              child: Text("Aucun utilisateur"),
            );
          } else {
            List documents = snap.data!.docs;

            return ListView.builder(
  itemCount: documents.length,
  itemBuilder: (context, index) {
    MyUser user = MyUser.bdd(documents[index]);
    if (moi.email != user.email) {
      return Card(
        elevation: 5,
        color: Colors.purple,
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.avatar!),
          ),
          title: Text(user.fullName),
          subtitle: Text(user.email),
          onTap: () {
            _showUserInfoDialog(user); // Afficher la boîte de dialogue avec les informations de l'utilisateur.
          },
          trailing: IconButton(
            icon: Icon(user.favori ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                  user.favori = !user.favori;
              });

              Map<String,dynamic> map = {
                  "FAVORI": user.favori
              };

              FirebaseHelper().updateUser(user.uid, map);

            },
          ),
        ),
      );
    } else {
      return Container();
    }
  },
);
          }
        });
  }
  void _showUserInfoDialog(MyUser user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Informations de l'utilisateur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom: ${user.nom}"),
            Text("Prénom: ${user.prenom}"),
            Text("Email: ${user.email}"),
            // Ajoutez d'autres informations que vous souhaitez afficher.
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Fermer"),
          ),
        ],
      );
    },
  );
}

}