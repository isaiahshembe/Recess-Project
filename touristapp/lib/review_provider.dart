import 'package:flutter/material.dart';
import 'review.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  void addReview(Review review) {
    _reviews.add(review);
    notifyListeners();
  }
}
