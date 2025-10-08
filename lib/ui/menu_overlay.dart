import 'package:flutter/material.dart';
import 'package:go_dino/service/logger.dart';

class MenuOverlay extends StatelessWidget {
  const MenuOverlay({super.key});

@override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: (){
          LogManager.debug("To Settings!");
        }, child: const Text("Settings")
        ),
        ElevatedButton(onPressed: (){
          LogManager.debug("To Menu!");
        }, child: const Text("Menu")
        ),
        ElevatedButton(onPressed: (){
          LogManager.debug("To Inventory!");
        }, child: const Text("Rucksack")
        ),
      ],
    ),
    );
  }
}