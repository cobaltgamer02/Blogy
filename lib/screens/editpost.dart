import 'package:blog/DB/postservice.dart';
import 'package:blog/models/posts.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class EditPost extends StatefulWidget {
  final Post post;
  EditPost(this.post);
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  // final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey = new GlobalKey();
  late Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
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
                child: TextFormField(initialValue: widget.post.title,
                  decoration: InputDecoration(labelText: 'Post Title',contentPadding: EdgeInsets.all(20),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  onSaved: (val) => widget.post.title = val!,
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
                child: TextFormField(initialValue: widget.post.body,
                  decoration: InputDecoration(labelText: 'Post Body',contentPadding: EdgeInsets.all(20),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  onSaved: (val) => widget.post.body = val!,
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
            Icons.edit,
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
      widget.post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(widget.post.toMap());
      postService.UpdatePost();
    }
  }
}
