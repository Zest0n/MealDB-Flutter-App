import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // 1. Search meals by keyword
  static Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List).map((json) => Meal.fromJson(json)).toList();
    }
    throw Exception('Failed to search meals');
  }

  // 2. Fetch full meal details by ID
  static Future<Meal> getMealDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJson(data['meals'][0]);
    }
    throw Exception('Failed to load meal details');
  }

  // 3. Get all meal categories
  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List).map((json) => Category.fromJson(json)).toList();
    }
    throw Exception('Failed to load categories');
  }

  // 4. Filter recipes by category
  static Future<List<Meal>> filterByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List).map((json) => Meal.fromJson(json)).toList();
    }
    throw Exception('Failed to filter by category');
  }

  // 5. Filter recipes by main ingredient
  static Future<List<Meal>> filterByIngredient(String ingredient) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?i=$ingredient'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List).map((json) => Meal.fromJson(json)).toList();
    }
    throw Exception('Failed to filter by ingredient');
  }

  // 6. Fetch a random recipe
  static Future<Meal> getRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJson(data['meals'][0]);
    }
    throw Exception('Failed to fetch random meal');
  }
}