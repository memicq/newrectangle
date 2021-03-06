// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: Import relevant packages

import 'dart:convert';
import 'dart:io';

import 'package:newrectangle/unit.dart';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {

  // TODO: Add any relevant variables and helper functions
  final httpClient = HttpClient();
  final url = 'flutter.udacity.com';

  // TODO: Create getUnits()
  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the name of the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
  Future<List<Unit>> getUnits() async {
    final uri = Uri.https(url, 'currency');
    final httpRequest = await httpClient.getUrl(uri);
    final httpResponse = await httpRequest.close();

    if (httpResponse.statusCode != HttpStatus.OK) { return null; }

    final responseBody = await httpResponse.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);

    if (jsonResponse is! Map) { throw ('Wrong api response.'); }

    var units = <Unit>[];
    for (Map unitData in jsonResponse['units']) {
      units.add( Unit(name: unitData['name'], conversion: unitData['conversion'].toDouble()) );
    }

    return units;
  }

  // TODO: Create convert()
  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.
  Future<double> convert(String amount, String fromUnit, String toUnit) async {
    final uri = Uri.https(url, 'currency/convert',
        { 'amount': amount, 'from': fromUnit, 'to': toUnit });
    final httpRequest = await httpClient.getUrl(uri);
    final httpResponse = await httpRequest.close();

    if (httpResponse.statusCode != HttpStatus.OK) { return null; }

    final responseBody = await httpResponse.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);

    if (jsonResponse is! Map) { throw ('Wrong api response.'); }

    return jsonResponse['conversion'].toDouble();
  }
}
