import 'package:blog/models/posts.dart';
import 'package:blog/screens/viewpost.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'addpost.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nodeName = 'posts';
  FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Post> postsList = <Post>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoves);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Blogs"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black45,
        child: Column(
          children: [
            Visibility(
              visible: postsList.isEmpty,
              child: Center(
                  child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )),
            ),
            Visibility(
              visible: postsList.isNotEmpty,
              child: Flexible(
                child: FirebaseAnimatedList(
                  query: _database.reference().child('posts'),
                  itemBuilder: (context, DataSnapshot snap,
                      Animation<double> animation, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewPost(postsList[index]),
                              ),
                            );
                          },
                          title: Text(
                            postsList[index].title,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  postsList[index].date),
                            ),
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          ),
                          subtitle: Text(postsList[index].body),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPost(),
              ),
            );
          },
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          tooltip: 'Add a post'),
    );
  }

  void _childAdded(Event event) {
    setState(() {
      postsList.add(
        Post.fromSnapshot(event.snapshot),
      );
    });
  }
  void _childRemoves(Event event) {
    var deletedPost = postsList.singleWhere((post) => post.key == event.snapshot.key);
    setState(() {
      postsList.removeAt(postsList.indexOf(deletedPost));
    });
  }
  void _childChanged(Event event){
    var changedPost = postsList.singleWhere((post) => post.key == event.snapshot.key);
    setState(() {
      postsList[postsList.indexOf(changedPost)] = Post.fromSnapshot(event.snapshot);
    });
  }

}


