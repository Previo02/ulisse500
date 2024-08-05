import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/provider.dart';
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
    final museums = [
      {
        'name': 'Museo di Palazzo Poggi',
        'coord': const LatLng(44.4952, 11.3520),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/museo-di-palazzo-poggi'
      },
      {
        'name': 'Museo Europeo degli Studenti - MEUS',
        'coord': const LatLng(44.4958, 11.3459),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/museo-europeo-degli-studenti-meus'
      },
      {
        'name': 'Museo della Specola',
        'coord': const LatLng(44.4965, 11.3519),
        'url': 'https://sma.unibo.it/it/il-sistema-museale/museo-della-specola'
      },
      {
        'name': 'Collezione di Zoologia',
        'coord': const LatLng(44.4946, 11.3439),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-zoologia'
      },
      {
        'name': 'Collezione di Anatomia Comparata',
        'coord': const LatLng(44.4942, 11.3443),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-anatomia-comparata'
      },
      {
        'name': 'Collezione di Antropologia',
        'coord': const LatLng(44.4941, 11.3441),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-antropologia'
      },
      {
        'name': 'Collezione di Chimica "Giacomo Ciamician"',
        'coord': const LatLng(44.4943, 11.3452),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-chimica-giacomo-ciamician'
      },
      {
        'name': 'Collezione di Geologia "Museo Giovanni Capellini"',
        'coord': const LatLng(44.4936, 11.3425),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-geologia-giovanni-capellini'
      },
      {
        'name': 'Collezione di Mineralogia "Museo Luigi Bombicci"',
        'coord': const LatLng(44.4938, 11.3431),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-mineralogia-luigi-bombicci'
      },
      {
        'name': 'Collezione delle Cere Anatomiche "Luigi Cattaneo"',
        'coord': const LatLng(44.4927, 11.3468),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-delle-cere-anatomiche-l-cattaneo'
      },
      {
        'name': 'Collezione di Fisica',
        'coord': const LatLng(44.4945, 11.3455),
        'url': 'https://sma.unibo.it/it/il-sistema-museale/collezione-di-fisica'
      },
      {
        'name': 'Orto Botanico ed Erbario',
        'coord': const LatLng(44.4964, 11.3514),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/orto-botanico-ed-erbario'
      },
      {
        'name': 'Collezione di Anatomia degli Animali Domestici',
        'coord': const LatLng(44.4926, 11.3436),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-anatomia-degli-animali-domestici'
      },
      {
        'name':
            'Collezione di Anatomia Patologica e Teratologia Veterinaria "Alessandrini - Ercolani"',
        'coord': const LatLng(44.4925, 11.3435),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-anatomia-patologica-e-teratologia-veterinaria'
      },
      {
        'name': 'Museo Officina dell\'Educazione - MODE',
        'coord': const LatLng(44.4957, 11.3499),
        'url': 'https://sma.unibo.it/it/il-sistema-museale/mode'
      },
    ];

    for (var museum in museums) {
      final marker = Marker(
        width: 70.0,
        height: 70.0,
        point: museum['coord'] as LatLng,
        child: IconButton(
          icon: const Icon(Icons.location_on),
          color: Colors.red,
          iconSize: 40.0,
          onPressed: () {
            _openGooglePage(museum['url'] as String);
          },
        ),
      );
      _markers.add(marker);
    }
    setState(() {});
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              child: const Icon(Icons.logout),
              onTap: () => Provider.of<AuthProvider>(context, listen: false).signOut()),
        ),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(44.494887, 11.342616),
          minZoom: 3.0,
          maxZoom: 18.0,
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
