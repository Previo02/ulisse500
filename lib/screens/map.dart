import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: const LatLng(44.494887, 11.342616),
        child: IconButton(
          icon: const Icon(Icons.location_on),
          color: Colors.red,
          iconSize: 40.0,
          onPressed: () {
            _openGooglePage(
                'https://www.google.com/search?q=Museo+di+Palazzo+Poggi');
          },
        ),
      ),
    );
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
          maxZoom: 150.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
