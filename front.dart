import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuotePage(),  
  ));
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String selectedTopic = "success";
  List quotes = [];
  bool isLoading = false;

  final TextEditingController searchController = TextEditingController();

  // ⚠️ Replace with your actual hosted backend URL
  String baseUrl = "https://quotes-backend-cqzs.onrender.com";



  Future<void> generateQuotes() async {
    setState(() => isLoading = true);
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"topic": selectedTopic}),
      );
      final data = jsonDecode(res.body);
      setState(() => quotes = data["quotes"] ?? []);
    } catch (e) {
      print("Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quote Generator"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedTopic,
              isExpanded: true,
              items: ["success", "love", "life", "study", "motivation"]
                  .map((topic) => DropdownMenuItem(
                        value: topic,
                        child: Text(topic.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedTopic = value!),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: generateQuotes,
              child: Text("Generate Quotes"),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            Expanded(
              child: quotes.isEmpty
                  ? Center(child: Text("No quotes yet. Try generating one."))
                  : ListView.builder(
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              quotes[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
