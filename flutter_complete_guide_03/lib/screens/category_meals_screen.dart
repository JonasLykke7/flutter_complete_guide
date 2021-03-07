import 'package:flutter/material.dart';

import '../widgets/meal_item.dart';

import '../models/meal.dart';

class CategotyMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';
  final List<Meal> avaiableMeals;

  CategotyMealsScreen(this.avaiableMeals);

  @override
  _CategotyMealsScreenState createState() => _CategotyMealsScreenState();
}

class _CategotyMealsScreenState extends State<CategotyMealsScreen> {
  String categoryTitle;
  List<Meal> displayedMeals;
  var _loadedInitData = false;

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      final categoryID = routeArgs['id'];
      displayedMeals = widget.avaiableMeals.where((meal) {
        return meal.categories.contains(categoryID);
      }).toList();

      _loadedInitData = true;
    }

    super.didChangeDependencies();
  }

  void _removeMeal(String mealID) {
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
              id: displayedMeals[index].id,
              title: displayedMeals[index].title,
              imageURL: displayedMeals[index].imageURL,
              duration: displayedMeals[index].duration,
              complexity: displayedMeals[index].complexity,
              affordability: displayedMeals[index].affordability);
        },
        itemCount: displayedMeals.length,
      ),
    );
  }
}
