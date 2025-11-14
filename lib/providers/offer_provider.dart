import 'package:flutter/foundation.dart';
import 'package:levelup/models/Offer.dart';
import 'package:levelup/services/offerservice.dart';

class OfferProvider extends ChangeNotifier {
  final Offerservice _offerService = Offerservice();

  List<Offer> _offers = [];
  bool _loading = false;
  String? _error;

  List<Offer> get offers => _offers;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchOffers() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedOffers = await _offerService.getOffers();
      _offers = fetchedOffers;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOffers() async {
    await fetchOffers();
  }

  void clear() {
    _offers = [];
    _error = null;
    _loading = false;
    notifyListeners();
  }
}
