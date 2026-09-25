import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/animated_widgets.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  List<Category> categories = [];
  List<Meal> meals = [];
  bool isLoading = true;
  String errorMessage = '';
  String activeCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final fetchedCategories = await ApiService.getCategories();
      final defaultMeals = await ApiService.searchMeals('chicken');
      setState(() {
        categories = fetchedCategories;
        meals = defaultMeals;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load meal data';
        isLoading = false;
      });
    }
  }

  void _filterByCategory(String catName) async {
    setState(() {
      activeCategory = catName;
      isLoading = true;
    });
    try {
      List<Meal> fetched = catName == 'All'
          ? await ApiService.searchMeals('chicken')
          : await ApiService.filterByCategory(catName);
      setState(() => meals = fetched);
    } catch (_) {
      setState(() => errorMessage = 'Error fetching category');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _fetchRandomMeal() async {
    setState(() => isLoading = true);
    try {
      final randomMeal = await ApiService.getRandomMeal();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: randomMeal.id)),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load random recipe')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showProfileOverlay() {
    final User? user = _authService.currentUser;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color.fromARGB(255, 199, 36, 14),
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person, color: Colors.white, size: 40) : null,
            ),
            const SizedBox(height: 12),
            Text(user?.displayName ?? 'User Account', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(user?.email ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                _authService.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 199, 36, 14),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealDB Recipes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino_outlined, color: Color.fromARGB(255, 199, 36, 14)),
            tooltip: 'Random Meal',
            onPressed: _fetchRandomMeal,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color.fromARGB(255, 199, 36, 14)),
            onPressed: _showProfileOverlay,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live Autocomplete Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Autocomplete<Meal>(
                displayStringForOption: (meal) => meal.name,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.trim().isEmpty) return const Iterable<Meal>.empty();
                  return await ApiService.searchMeals(textEditingValue.text);
                },
                onSelected: (Meal selection) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: selection.id)),
                  );
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search recipes...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildCategoryChip('All'),
                  ...categories.map((c) => _buildCategoryChip(c.name)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Main Meal Content area with Animated Data Transition
            Expanded(
              child: isLoading
                  ? const PulseLoadingIndicator()
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : meals.isEmpty
                          ? const Center(child: Text('No recipes found'))
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: ListView.builder(
                                key: ValueKey<String>(activeCategory + meals.length.toString()),
                                itemCount: meals.length,
                                itemBuilder: (context, index) {
                                  final meal = meals[index];
                                  return AnimatedScalePress(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MealDetailScreen(mealId: meal.id),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                            child: Image.network(
                                              meal.thumbnail,
                                              width: 110,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              meal.name,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Icon(Icons.chevron_right, color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final bool isSelected = activeCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color.fromARGB(255, 199, 36, 14),
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (_) => _filterByCategory(label),
      ),
    );
  }
}