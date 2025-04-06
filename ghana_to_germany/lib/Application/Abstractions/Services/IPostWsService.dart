abstract class IPostWsService {
  Future<void> initConnection();
  void onNewPostReceived();
  void onNewNewsReceived(Function(String) callback);
  void onNewWikiReceived(Function(String) callback);
}