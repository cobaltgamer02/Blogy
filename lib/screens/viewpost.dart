import 'package:blog/models/posts.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:blog/DB/postservice.dart';
import 'package:blog/screens/HomePage.dart';
import 'package:blog/screens/editpost.dart';
class ViewPost extends StatefulWidget {
  final Post post;
  ViewPost(this.post);
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    timeago.format(
                      DateTime.fromMillisecondsSinceEpoch(widget.post.date),
                    ),
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      PostService postService = PostService(widget.post.toMap());
                      postService.DeletePost();
                      Navigator.pop(context);
                    });
                  },
                  icon: Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPost(widget.post)));
                  },
                  icon: Icon(Icons.edit)),
            ],
          ),
          Divider(),
          Padding(padding: EdgeInsets.all(10), child: Text(widget.post.body)),
        ],
      ),
    );
  }
}
