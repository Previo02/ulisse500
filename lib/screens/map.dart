import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/screens/login.dart';
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
        'coord': const LatLng(44.495777, 11.354173),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-zoologia'
      },
      {
        'name': 'Collezione di Anatomia Comparata',
        'coord': const LatLng(44.495777, 11.354173),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-anatomia-comparata'
      },
      {
        'name': 'Collezione di Antropologia',
        'coord': const LatLng(44.495777, 11.354173),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-antropologia'
      },
      {
        'name': 'Collezione di Chimica "Giacomo Ciamician"',
        'coord': const LatLng(44.496536, 11.354189),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-chimica-giacomo-ciamician'
      },
      {
        'name': 'Collezione di Geologia "Museo Giovanni Capellini"',
        'coord': const LatLng(44.497843, 11.355306),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-geologia-giovanni-capellini'
      },
      {
        'name': 'Collezione di Mineralogia "Museo Luigi Bombicci"',
        'coord': const LatLng(44.498195, 11.355444),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-mineralogia-luigi-bombicci'
      },
      {
        'name': 'Collezione delle Cere Anatomiche "Luigi Cattaneo"',
        'coord': const LatLng(44.499027, 11.355315),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-delle-cere-anatomiche-l-cattaneo'
      },
      {
        'name': 'Collezione di Fisica',
        'coord': const LatLng(44.49937, 11.353879),
        'url': 'https://sma.unibo.it/it/il-sistema-museale/collezione-di-fisica'
      },
      {
        'name': 'Orto Botanico ed Erbario',
        'coord': const LatLng(44.500139, 11.352991),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/orto-botanico-ed-erbario'
      },
      {
        'name': 'Collezione di Anatomia degli Animali Domestici',
        'coord': const LatLng(44.435227, 11.486098),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-anatomia-degli-animali-domestici'
      },
      {
        'name':
            'Collezione di Anatomia Patologica e Teratologia Veterinaria "Alessandrini - Ercolani"',
        'coord': const LatLng(44.435227, 11.486098),
        'url':
            'https://sma.unibo.it/it/il-sistema-museale/collezione-di-anatomia-patologica-e-teratologia-veterinaria'
      },
      {
        'name': 'Museo Officina dell\'Educazione - MODE',
        'coord': const LatLng(44.4957, 11.3499),
        'url': 'https://sma.unibo.it/it/il-sistema-museale/mode',
      },
    ];

    for (var museum in museums) {
      final marker = Marker(
        width: 70.0,
        height: 70.0,
        point: museum['coord'] as LatLng,
        child: Tooltip(
          message: museum['name'] as String,
          child: IconButton(
            icon: const Icon(Icons.location_on),
            color: Colors.red,
            iconSize: 40.0,
            onPressed: () => _openGooglePage(museum['url'] as String),
          ),
        ),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  Future<void> _openGooglePage(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      _showErrorDialog('Could not launch $url');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mappa Museale"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: const Icon(Icons.logout),
            onTap: () async {
              await Provider.of<PrivateProvider>(context, listen: false)
                  .signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(44.494887, 11.342616),
          minZoom: 7.0,
          maxZoom: 25.0,
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
