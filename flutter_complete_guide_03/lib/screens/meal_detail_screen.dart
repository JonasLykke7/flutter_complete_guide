import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  @override
  Widget build(BuildContext context) {
    final mealID = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$mealID',
        ),
      ),
      body: Center(
        child: Text(
          'The Meal - $mealID',
        ),
      ),
    );
  }
}
