import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

bool _loading = true;
List<dynamic> posts = [];
final TextEditingController _titleController = new TextEditingController();
final TextEditingController _bodyController = new TextEditingController();
String _title;
String _body;
String serverURL = "http://localhost:7777";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FullStack demo - @aqeelshamz"),
      ),
      body: Padding(
        padding: EdgeInsets.all(Get.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title"),
            TextField(
              controller: _titleController,
              onChanged: (txt) {
                _title = txt;
              },
            ),
            SizedBox(height: Get.height * 0.04),
            Text("Body"),
            TextField(
              controller: _bodyController,
              onChanged: (txt) {
                _body = txt;
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              children: [
                RaisedButton(
                  onPressed: () {
                    savePost();
                  },
                  child: Text("POST"),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                RaisedButton(
                  onPressed: () {
                    getPosts();
                    Fluttertoast.showToast(msg: "Posts reloaded");
                  },
                  child: Text("REFRESH"),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            _loading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : posts.length == 0
                    ? Expanded(
                        child: Center(
                          child: Text("No posts"),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: Get.height * 0.02),
                              onPressed: (){},
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Delete post?"),
                                        content: Text(
                                            "Are you sure, want to delete this post?"),
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text("CANCEL")),
                                          FlatButton(
                                              onPressed: () {
                                                deletePost(posts[index]['_id']);
                                                Get.back();
                                              },
                                              child: Text(
                                                "DELETE",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Title:\n" +
                                            posts[index]['title'] +
                                            "\n"),
                                        Text("Body:\n" +
                                            posts[index]['body'] +
                                            "\n"),
                                      ]),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  getPosts() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get("$serverURL/posts");
    setState(() {
      _loading = false;
      posts = jsonDecode(response.body);
      posts = posts.reversed.toList();
    });
  }

  savePost() async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = {"title": _title, "body": _body};
    var response = await http.post("$serverURL/posts",
        headers: headers, body: jsonEncode(body));

    if (response.body == "Post saved!") {
      Fluttertoast.showToast(msg: "Posted!");
      setState(() {
        _titleController.clear();
        _bodyController.clear();
      });
      getPosts();
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  deletePost(String id) async {
    var response = await http.delete("$serverURL/posts/$id");
    if (response.body == "Post deleted!") {
      Fluttertoast.showToast(msg: "Post deleted");
      getPosts();
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }
}
