import 'package:flutter/material.dart';

class HomeFiltersComponent extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const HomeFiltersComponent({super.key, required this.onApplyFilters});

  @override
  State<HomeFiltersComponent> createState() => _HomeFiltersComponentState();
}

class _HomeFiltersComponentState extends State<HomeFiltersComponent> {
  final Map<String, bool> _layoutFilters = {
    "65%": false,
    "75%": false,
    "TKL (Tenkeyless)": false,
    "100% (Full-size)": false,
  };

  final Map<String, bool> _connectivityFilters = {
    "Wireless": false,
    "Com fio": false,
  };

  final Map<String, bool> _keycapFilters = {
    "Cherry": false,
    "OEM": false,
    "SA": false,
    "XDA": false,
    "DSA": false,
  };

  final Map<String, bool> _productTypeFilters = {
    "Teclado Mecânico": false,
    "Switch": false,
    "Keycap": false,
  };

  void _applyFilters() {
    List<String> getSelectedFilters(Map<String, bool> filterMap) {
      final List<String> selected = [];
      filterMap.forEach((key, value) {
        if (value) {
          selected.add(key);
        }
      });
      return selected;
    }

    final Map<String, List<String>> apiFilters = {
      "layoutSize": getSelectedFilters(_layoutFilters),
      "connectionType": getSelectedFilters(_connectivityFilters),
      "keycapsType": getSelectedFilters(_keycapFilters),
      "productType": getSelectedFilters(_productTypeFilters),
    };

    widget.onApplyFilters(apiFilters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 65, 72, 74),
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Color.fromARGB(255, 65, 72, 74)),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext modalContext) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) =>
                  SizedBox(
                    height: MediaQuery.of(modalContext).size.height * 0.5,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            ExpansionTile(
                              title: Text("Tamanho do layout"),
                              children: _layoutFilters.keys.map((String key) {
                                return CheckboxListTile(
                                  title: Text(key),
                                  value: _layoutFilters[key],
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      _layoutFilters[key] = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            ExpansionTile(
                              title: Text("Conectividade"),
                              children: _connectivityFilters.keys.map((
                                String key,
                              ) {
                                return CheckboxListTile(
                                  title: Text(key),
                                  value: _connectivityFilters[key],
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      _connectivityFilters[key] = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            ExpansionTile(
                              title: Text("Tipo de keycap"),
                              children: _keycapFilters.keys.map((String key) {
                                return CheckboxListTile(
                                  title: Text(key),
                                  value: _keycapFilters[key],
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      _keycapFilters[key] = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            ExpansionTile(
                              title: Text("Tipo de produto"),
                              children: _productTypeFilters.keys.map((
                                String key,
                              ) {
                                return CheckboxListTile(
                                  title: Text(key),
                                  value: _productTypeFilters[key],
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      _productTypeFilters[key] = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () => _applyFilters(),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.transparent),
                              ),
                              child: Text(
                                "Aplicar",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            );
          },
        );
      },
      child: Row(
        children: [
          Expanded(child: Text("Filtros")),
          Icon(Icons.tune),
        ],
      ),
    );
  }
}
