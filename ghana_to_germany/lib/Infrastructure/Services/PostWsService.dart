import 'dart:convert';

import 'package:ghana_to_germany/Application/Abstractions/Services/IPostWsService.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'dart:developer' as developer;

class PostWsService implements IPostWsService {
  late HubConnection hubConnection;
  PostsViewModel postsViewModel;

  PostWsService({required this.postsViewModel}) {
    initConnection();
  }

  @override
  Future<void> initConnection() async {
    hubConnection =
        HubConnectionBuilder().withUrl("https://stellar-stream.shipeazi.com/postHub").build();

    // start connection
    await hubConnection.start();
    developer.log("Connected to SignalR Hub");
  }

  @override
  void onNewPostReceived() {
    hubConnection.on("ReceiveNewPost", (postData) {
      var jsonData = jsonEncode(postData);
      var jsonArray = jsonDecode(jsonData);

      var post = Post.postsFromJson(jsonArray);
      postsViewModel.receiveCreatedPost(post.first);
    });
  }

  @override
  void onNewNewsReceived(Function(String p1) callback) {
    hubConnection.on("ReceiveNewNews", (newsData) {
      callback(newsData.toString()); // Assuming postData is a list
    });
  }

  @override
  void onNewWikiReceived(Function(String p1) callback) {
    hubConnection.on("ReceiveNewWiki", (wikiData) {
      callback(wikiData.toString()); // Assuming postData is a list
    });
  }
}
