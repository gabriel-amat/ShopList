import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: "Pesquisa suas listas aqui.",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                ),
              ),
            ),
          ),
          SizedBox(width: 8,),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.add,color: Colors.white, size: 27,)
          )
        ],
      ),
    );
  }
}