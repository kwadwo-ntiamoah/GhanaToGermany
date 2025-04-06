import 'package:flutter/cupertino.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getNews.usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

import 'shared/form_status.dart';

class NewsViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final GetNewsUseCase getNewsUseCase;

  NewsViewModel({ required this.getNewsUseCase });

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  final List<Post> _news = [];
  List<Post> get news =>_news;

  Future<void> getNews() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var data = await getNewsUseCase.execute(Nothing());
      _news.clear();
      _news.addAll(data);

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }
}