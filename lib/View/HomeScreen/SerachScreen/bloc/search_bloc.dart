import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/product_get_model.dart';
import 'package:flutter_application_ecommerce/ViewModel/Home/HomeRepository/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepository homeRepository;
  SearchBloc({required this.homeRepository}) : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      try {
        if (event is InitialSearchScreen) {
          emit(SearchingScreen());
        } else if (event is SearchStart) {
          emit(SearchLoading());
          final productList = await homeRepository.getProductsWithKeyWord(
              keyWord: event.searchKeyWord);
          if (productList.isNotEmpty) {
            emit(SearchSuccess(productList: productList));
          } else {
            emit(SearchEmptyScreen());
          }
        }
      } catch (e) {
        emit(SearchError());
      }
    });
  }
}

// Future<List<ProductGetModels>> getData(String content) async {
//   final response = await get(Uri.parse('http://172.17.32.1:8080/api/v1/product?s=$content'));
//   var data = jsonDecode(response.body.toString());
//
//   if (response.statusCode == 200) {
//     for (Map<String, dynamic> index in data) {
//       productBySearchData.add(ProductGetModels.fromJson(index));
//     }
//     return productBySearchData;
//   }
//   return productBySearchData; //empty list
// }