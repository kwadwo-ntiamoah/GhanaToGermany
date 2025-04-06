import 'package:flutter/cupertino.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addWiki.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getWikis.usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

import 'shared/form_status.dart';

class WikisViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final GetWikisUseCase getWikisUseCase;
  final AddWikiUseCase addWikiUseCase;

  WikisViewModel({ required this.getWikisUseCase, required this.addWikiUseCase });

  FormStatus _status = FormStatus.INIT;
  FormStatus _addWikiStatus = FormStatus.INIT;
  FormStatus get status => _status;
  FormStatus get addWikiStatus => _addWikiStatus;

  final List<Post> _wikis = [];
  List<Post> get wikis =>_wikis;

  final TextEditingController _contentController = TextEditingController();
  TextEditingController get contentController => _contentController;

  Future<void> getWikis() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var data = await getWikisUseCase.execute(Nothing());
      _wikis.clear();
      _wikis.addAll(data);

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  Future addWiki(String tag) async {
    try {
      _addWikiStatus = FormStatus.LOADING;
      notifyListeners();

      var payload = AddWikiPayload(content: _contentController.value.text, tag: tag);
      await addWikiUseCase.execute(payload);

      _addWikiStatus = FormStatus.SUCCESSFUL;
      notifyListeners();
    } catch (e) {
      _addWikiStatus = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _addWikiStatus = FormStatus.INIT;
    _status = FormStatus.INIT;
    _contentController.clear();

    notifyListeners();
  }
}