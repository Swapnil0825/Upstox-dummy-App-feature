import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upstox Stock Price',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StockPriceScreen(),
    );
  }
}

class StockPriceScreen extends StatefulWidget {
  @override
  _StockPriceScreenState createState() => _StockPriceScreenState();
}

class _StockPriceScreenState extends State<StockPriceScreen> {
  TextEditingController _controller = TextEditingController();
  String _stockPrice = '';
  String _errorMessage = '';

  Future<void> _fetchStockPrice(String symbol) async {
    final url = Uri.parse('http://localhost:3000/api/stock/$symbol');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _stockPrice = data['price'].toString();
          _errorMessage = '';
        });
      } else {
        setState(() {
          _errorMessage = 'Stock not found';
          _stockPrice = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch stock price';
        _stockPrice = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upstox Stock Price'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Stock Symbol',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchStockPrice(_controller.text);
              },
              child: Text('Get Stock Price'),
            ),
            SizedBox(height: 20),
            if (_stockPrice.isNotEmpty)
              Text(
                'Stock Price: $_stockPrice',
                style: TextStyle(fontSize: 24),
              ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
