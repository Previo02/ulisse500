import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulisse Aldrovandi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: FlipCard(
          controller: _controller,
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          front: _buildFrontCard(),
          back: _buildBackCard(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 92, 200, 214),
        onPressed: () {
          _controller.toggleCard();
        },
        child: const Icon(Icons.flip),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/aldrovandi.jpeg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storia di Ulisse Aldrovandi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ulisse Aldrovandi (1522-1605) è stato un famoso naturalista e botanico italiano. '
              'Considerato uno dei fondatori della moderna storia naturale, Aldrovandi ha giocato '
              'un ruolo fondamentale nello sviluppo delle scienze naturali. Durante la sua vita, '
              'ha raccolto un\'immensa quantità di reperti naturalistici che sono diventati parte '
              'di varie collezioni, inclusa la famosa collezione zoologica di Bologna. I suoi studi '
              'e le sue pubblicazioni hanno influenzato generazioni di scienziati e naturalisti.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              'Le sue opere includono:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• "Ornithologiae" (1599) - Un lavoro sulla classificazione degli uccelli\n'
              '• "De Animalibus Insectis" (1602) - Uno dei primi studi sistematici sugli insetti\n'
              '• "De Reliquis Animalibus" (1603) - Uno studio sugli altri animali',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
