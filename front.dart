import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quotes App")),
      body: Center(
        child: Text(
          "Hello World",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}




class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String selectedTopic = "success";
  List quotes = [];
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  String baseUrl = "http://127.0.0.1:8000"; // ✅ correct for Chrome

  Future<void> generateQuotes() async {
    setState(() => isLoading = true);

    try {
      var res = await http.post(
        Uri.parse("$baseUrl/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"topic": selectedTopic}),
      );

      var data = jsonDecode(res.body);

      setState(() {
        quotes = data["quotes"] ?? [];
      });
    } catch (e) {
      print(e);
    }

    setState(() => isLoading = false);
  }

// 
//   Future<void> searchQuotes() async {
//     setState(() => isLoading = true);

//     try {
//       var res = await http.post(
//         Uri.parse("$baseUrl/search"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"query": searchController.text}),
//       );

//       var data = jsonDecode(res.body);

//       setState(() {
//         quotes = data["quotes"] ?? [];
//       });
//     } catch (e) {
//       print(e);
//     }

//     setState(() => isLoading = false);
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quote Generator"),
        centerTitle: true,
      ),
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
              onChanged: (value) {
                setState(() => selectedTopic = value!);
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: generateQuotes,
              child: Text("Generate Quotes"),
            ),
            SizedBox(height: 20),

            // TextField(
            //   controller: searchController,
            //   decoration: InputDecoration(
            //     labelText: "Search quotes",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: searchQuotes,
            //   child: Text("Search"),
            // ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
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
            )
          ],
        ),
      ),
    );
  }
}
