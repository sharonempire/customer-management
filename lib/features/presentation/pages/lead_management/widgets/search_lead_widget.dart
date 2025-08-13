
import 'package:flutter/material.dart';

class SearchLeadsWidget extends StatelessWidget {
  const SearchLeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            SizedBox(
              width: 350,
              height: 28,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search Leads...",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 18),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
