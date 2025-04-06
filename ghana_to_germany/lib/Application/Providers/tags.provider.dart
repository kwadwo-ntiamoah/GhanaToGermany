import 'package:flutter/cupertino.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getTags.usecase.dart';
import 'package:ghana_to_germany/Domain/Tag/tag.dart';

import 'shared/form_status.dart';

class TagsViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final GetTagsUseCase getTagsUseCase;

  TagsViewModel({ required this.getTagsUseCase });

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  final List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  String? _selectedTag = "";
  String? get selectedTag => _selectedTag;

  Future<void> getTags() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var data = await getTagsUseCase.execute(Nothing());
      tags.clear();
      _tags.addAll(data);

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;

      notifyError("An error occurred retrieving tags");
      notifyListeners();
    }
  }

  void resetState() {
    _status = FormStatus.INIT;
    notifyListeners();
  }

  void setTag(String tag) {
    _selectedTag = tag;
    notifyListeners();
  }
}