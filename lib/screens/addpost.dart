import 'package:blog/DB/postservice.dart';
import 'package:blog/models/posts.dart';
import 'package:blog/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:blog/models/posts.dart';
class AddPost extends StatefulWidget {

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  // final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey = new GlobalKey();
  late Post post;


  @override
  void initState() {
    post = Post(0,'','');
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Post Title',contentPadding: EdgeInsets.all(20),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  onSaved: (val) => post.title = val!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'title field cannot be empty';
                    }else if(value.length > 16){
                      return 'title cannot be greater than 16 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Post Body',contentPadding: EdgeInsets.all(20),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  onSaved: (val) => post.body = val!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'title field cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            insertPost();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          tooltip: 'Add a post'),
    );
  }

  void insertPost() {
    final FormState? form = formkey.currentState;
    if(form!.validate()){
      form.save();
      form.reset();
      post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(post.toMap());
      postService.Addpost();
    }
  }
}

