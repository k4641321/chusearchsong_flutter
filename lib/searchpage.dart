import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Search...'),
                ),
              ),

              IconButton(
                onPressed: () => print('test'),
                icon: Icon(Icons.search),
              ),
            ],
          ),
          // DropdownMenu<String>(dropdownMenuEntries: const Map(('title', 'Title'){'genre', 'Genre'}),
          // )
        ],
      ),
    );
  }
}
