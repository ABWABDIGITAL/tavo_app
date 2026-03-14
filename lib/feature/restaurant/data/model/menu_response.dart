import 'package:tavo/feature/restaurant/data/model/menu_category_model.dart';

import 'menu_item_model.dart';

class MenuResponse {
  final bool success;
  final String? message;
  final MenuData? data;

  MenuResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? MenuData.fromJson(json['data']) : null,
    );
  }
}

class MenuData {
  final List<MenuCategoryModel> categories;
  final List<MenuItemModel> items;
  final PaginationModel? pagination;

  MenuData({
    required this.categories,
    required this.items,
    this.pagination,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) {
    return MenuData(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => MenuCategoryModel.fromJson(e))
              .toList() ??
          [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : null,
    );
  }
}

class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int pages;
  final bool hasNext;
  final bool hasPrev;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.pages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 12,
      pages: json['pages'] ?? 1,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}