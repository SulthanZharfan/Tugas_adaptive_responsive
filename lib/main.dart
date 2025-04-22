import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

void main() => runApp(const AdaptiveDemo());

class AdaptiveDemo extends StatelessWidget {
  const AdaptiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Data dummy
  final _items = List<String>.generate(20, (i) => 'Acara Kampus#${i + 1}');

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Stack(
      children: [
        Scaffold(
          body: AdaptiveScaffold(
            useDrawer: false,
            selectedIndex: _selectedIndex,
            onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
              NavigationDestination(icon: Icon(Icons.event), label: 'Acara'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
            ],
            smallBody: (_) => _FeedGrid(cols: 1, items: _items),
            body: (context) {
              final width = MediaQuery.of(context).size.width;
              final cols = width < 905 ? 2 : 3;
              return _FeedGrid(cols: cols, items: _items);
            },
          ),
        ),

        if (isSmallScreen)
          Positioned(
            bottom: 120, // jarak dari bawah
            right: 25,  // jarak dari kanan
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menambahkan acara baru!'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}

class _FeedGrid extends StatelessWidget {
  const _FeedGrid({required this.cols, required this.items});
  final int cols;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: cols == 1 ? 5 : 3 / 2,
      ),
      itemBuilder: (_, i) => Card(
        elevation: 2,
        child: Center(
          child: Text(
            items[i],
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
