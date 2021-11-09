import 'package:blog/models/posts.dart';
import 'package:firebase_database/firebase_database.dart';
class PostService{
  String nodename = 'posts';
  FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  final Map post;
  PostService(this.post);
  Addpost(){
    //this is going to give a reference tot he posts node
    database.reference().child(nodename).push().set(post);
  }
  DeletePost(){
    database.reference().child('$nodename/${post['key']}').remove();
  }
  UpdatePost(){
    database.reference().child('$nodename/${post['key']}').update({"title": post['title'], "body": post['body'], "date":post['date']});
  }
}