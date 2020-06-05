# customgraph

A Flutter package for creating a custom graph with easy.

### Show some :heart: and star the repo to support the project
 If you love this package fork the project and star it.

## Installation

Clone the project and import the local package

```bash
git clone https://github.com/shashiben/flutter_custom_graph.git
```

## Usage
```
Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Custom Graph Example",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: Container(
          
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(10),
                child: Text(
                  "Example",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      
                      fontSize: 20),
                ),
              ),
              SizedBox(height: 20,),
              CustomGraph(
                  percentages: [2, 4, 6, 8, 10],
                  xAxisValues: ["A", "B", "C", "D", "E"],
                  yAxisValues: ["10", "8", "6", "4", "2", "0"],
                  rangeBegin: 0,
                  rangeEnd: 100,
                  xAxisLabelStart: 0,
                  indicatorTextMultiplier: 1,
                  noOfValuestoShow: 4)
            ],
          ),
        ),
      ),
```

## Screenshots
<p float="left">
  <img src="https://github.com/shashiben/flutter_custom_graph/blob/master/screenshots/ss1.png"  />
  <img src="https://github.com/shashiben/flutter_custom_graph/blob/master/screenshots/ss2.png"  />
  
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
