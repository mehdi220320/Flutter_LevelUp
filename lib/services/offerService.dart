import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:levelup/models/Offer.dart';
import 'package:levelup/models/environnement.dart';
import 'package:levelup/services/authentication.dart';

class Offerservice {
  final String baseUrl = Environnement().url;
  Future<List<Offer>> getOffers() async {
    final url = Uri.parse('$baseUrl/offers/');
    final token = await AuthService().getAccessToken();

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Convert each item of the response list into an Offer object
      final List<dynamic> offersJson = responseBody;
      final List<Offer> offers = offersJson
          .map((json) => Offer.fromJson(json))
          .toList();
      return offers;
    } else {
      throw Exception(responseBody['detail'] ?? 'Get Offers failed');
    }
  }
}
