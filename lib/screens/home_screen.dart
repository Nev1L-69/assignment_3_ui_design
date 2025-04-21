import 'package:flutter/material.dart';
import '../services/app_localization.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> itemNumbers = List.generate(20, (index) => index + 1);
  Set<int> expandedItems = {};

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.homeTitle),
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              localizations.welcome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemNumbers.length,
              itemBuilder: (context, index) {
                final itemNumber = itemNumbers[index];
                final isExpanded = expandedItems.contains(itemNumber);
                return Dismissible(
                  key: ValueKey(itemNumber),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      itemNumbers.removeAt(index);
                      expandedItems.remove(itemNumber);
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.star),
                          title: Text(localizations.itemTitle(itemNumber)),
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                expandedItems.remove(itemNumber);
                              } else {
                                expandedItems.add(itemNumber);
                              }
                            });
                          },
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(localizations.itemDescription(itemNumber)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            final newItemNumber = itemNumbers.isEmpty ? 1 : itemNumbers.last + 1;
            itemNumbers.add(newItemNumber);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              localizations.welcome,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(localizations.homeTitle),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(localizations.aboutTitle),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations.settingsTitle),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}