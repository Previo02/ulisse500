import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _fetchMuseums();
  }

  Future<void> _fetchMuseums() async {
    const query = '''
    SELECT ?museum ?museumLabel ?coord ?wikipedia WHERE {
      ?museum wdt:P31 wd:Q33506;      # I musei
              wdt:P131 wd:Q1272;      # Situati a Bologna
              wdt:P625 ?coord.        # Con coordinate geografiche
      OPTIONAL {
        ?wikipedia schema:about ?museum;
                   schema:inLanguage "it";
                   schema:isPartOf <https://it.wikipedia.org/>.
      }
      SERVICE wikibase:label { bd:serviceParam wikibase:language "it". }
    }
    ''';
    final url = Uri.parse(
        'https://query.wikidata.org/sparql?query=${Uri.encodeComponent(query)}&format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("Successo");
      final data = json.decode(response.body);
      final List<dynamic> museums = data['results']['bindings'];
      print(museums);
      _initializeMarkers(museums);
    } else {
      throw Exception('Failed to load museum data');
    }
  }

  void _initializeMarkers(List<dynamic> museums) {
    for (var museum in museums) {
      final coord = museum['coord']['value'];
      final latLng = _parseLatLng(coord);
      final wikipediaUrl = museum['wikipedia'] != null
          ? museum['wikipedia']['value']
          : 'https://www.google.com/search?q=${museum['museumLabel']['value']}';

      final marker = Marker(
        width: 70.0,
        height: 70.0,
        point: latLng,
        child: IconButton(
          icon: const Icon(Icons.location_on),
          color: Colors.red,
          iconSize: 40.0,
          onPressed: () {
            _openGooglePage(wikipediaUrl);
          },
        ),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  LatLng _parseLatLng(String coord) {
    final coords =
        coord.replaceAll('Point(', '').replaceAll(')', '').split(' ');
    final lat = double.parse(coords[1]);
    final lng = double.parse(coords[0]);
    return LatLng(lat, lng);
  }

  void _openGooglePage(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ulisse500"),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(44.494887, 11.342616),
          minZoom: 0,
          maxZoom: 75,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
