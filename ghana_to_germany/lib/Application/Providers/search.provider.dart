import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/UseCases/search.usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

import 'package:ghana_to_germany/Infrastructure/Services/DioHttpClient.dart';

class SearchViewModel extends ChangeNotifier with ErrorNotifierMixin{
  final SearchUseCase searchUseCase;

  SearchViewModel({ required this.searchUseCase });

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  final List<Post> _results = [];
  List<Post> get results => _results;

  Timer? _debounce;

  Future<void> search(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _postSearch(query);
      }
    });
  }

  Future<void> _postSearch(String query) async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var payload = SearchPayload(query: query);
      var response = await searchUseCase.execute(payload);

      _results.clear();
      _results.addAll(response);

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } on HttpException catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _status = FormStatus.INIT;
    _results.clear();

    notifyListeners();
  }
}