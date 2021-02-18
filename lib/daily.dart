import 'package:flutter/material.dart';

class Daily extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("asdasdasd"),
          Expanded(
                      child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                  "https://www.metaweather.com/static/img/weather/png/c.png"),
                            ),
                            Text(
                              "2° C",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black45,
                                        blurRadius: 5,
                                        offset: Offset(-3, 3))
                                  ]),
                            ),
                            Text(
                              "12/12/12",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black45,
                                        blurRadius: 5,
                                        offset: Offset(-3, 3))
                                  ]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
