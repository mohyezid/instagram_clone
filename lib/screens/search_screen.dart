import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils.dart/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(labelText: 'search a user  '),
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isSearching = true;
            });
          },
        ),
      ),
      body: isSearching
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ProfileScreen(
                                uid: snapshot.data!.docs[index]['uid']);
                          },
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]['photoUrl'])),
                        title: Text(snapshot.data!.docs[index]['username']),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data!.docs[index]['postUrl']);
                  },
                );
              },
            ),
    );
  }
}
