import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'widgets/profilepicture_widget.dart';
import 'edit_profile2.dart';
import 'package:corum/api/GetCookies.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>> fetchData(ConnectNetworkService request) async {
    String uname = request.username;
    String url = 'https://corum.up.railway.app/profile/user/' + uname;

    try {
      Map<String, dynamic> extractedData = {};

      final response = await http.get(Uri.parse(url));
      extractedData['profile'] = jsonDecode(response.body);

      return extractedData;
    } catch (error) {
      return {"Error": "error"};
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<ConnectNetworkService>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Profil"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.greenAccent.shade200,
        ),
        body: ListView(children: <Widget>[
          FutureBuilder(
            future: fetchData(request),
            builder: (context, snapshot) {
              if (snapshot.hasError) {}
              // print(snapshot.error);
              return snapshot.hasData
                  ? ItemList(
                      list: snapshot.data as Map,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ]));
  }
}

class ItemList extends StatelessWidget {
  final Map list;
  const ItemList({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstName = list['profile'][0]['fields']['first_name'].toString();
    String lastName = list['profile'][0]['fields']['last_name'].toString();
    String email = list['profile'][0]['fields']['email'].toString();
    String username = list['profile'][0]['fields']['username'].toString();
    String bio = list['profile'][1]['fields']['bio'].toString();
    String imagePath =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png';

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 40),
              child: ProfileWidget(
                imagePath: imagePath,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Depan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    firstName,
                    style: TextStyle(fontSize: 16, height: 2),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Belakang',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    lastName,
                    style: TextStyle(fontSize: 16, height: 2),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    username,
                    style: TextStyle(fontSize: 16, height: 2),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bio',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bio,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 30),
                    primary: Color.fromRGBO(59, 148, 94, 1.0),
                    shape: StadiumBorder(),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    "Edit Profil",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfilePageNoPic()),
                    );
                  }),
            )
          ],
        ));
  }
}
