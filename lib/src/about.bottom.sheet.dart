import 'dart:convert';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class AboutBottomSheet extends StatefulWidget {
  const AboutBottomSheet({super.key});

  @override
  State<AboutBottomSheet> createState() => _AboutBottomSheetState();
}

class _AboutBottomSheetState extends State<AboutBottomSheet> {
  String? about;

  @override
  void initState() {
    super.initState();
  }

  Future loadFromJson(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/fixture/about.json");
    final j = jsonDecode(data);
    setState(() {
      about = j['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    loadFromJson(context);
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).maybePop();
      },
      backgroundColor: Theme.of(context).disabledColor,
      startingOpacity: 0.2,
      direction: DismissiblePageDismissDirection.down,
      isFullScreen: false,
      child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * (1 / 12)),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    color: Theme.of(context).cardColor),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'About Linko',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 32,
                          color: Theme.of(context).disabledColor,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        about ?? '...',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}