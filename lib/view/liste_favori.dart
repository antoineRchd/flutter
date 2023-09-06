import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';

class ListFavori extends StatefulWidget {
  const ListFavori({super.key});

  @override
  State<ListFavori> createState() => _ListFavoriState();
}

class _ListFavoriState extends State<ListFavori> {
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
                  if(user.favori != false){

                  return Card(
                  elevation: 5,
                  color: Color.fromARGB(255, 255, 255, 58),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.avatar!),
                    ),
                    title: Text(user.email),
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