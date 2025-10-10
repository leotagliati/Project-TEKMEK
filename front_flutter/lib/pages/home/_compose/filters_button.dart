import 'package:flutter/material.dart';

class HomeFiltersComponent extends StatelessWidget {
  const HomeFiltersComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ExpansionTile(
                      title: Text("Tamanho do layout"),
                      children: [
                        CheckboxListTile(
                          title: Text("Filtro 1"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 2"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 3"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 4"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text("Conectividade"),
                      children: [
                        CheckboxListTile(
                          title: Text("Filtro 1"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 2"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 3"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 4"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text("Tipo de keycap"),
                      children: [
                        CheckboxListTile(
                          title: Text("Filtro 1"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 2"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 3"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 4"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text("Tipo de produto"),
                      children: [
                        CheckboxListTile(
                          title: Text("Filtro 1"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 2"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 3"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        CheckboxListTile(
                          title: Text("Filtro 4"),
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                      ],
                    ),
                  ],
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
