import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/tekmek-logo-clear.png',
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Início"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.local_mall),
              title: Text("Meus pedidos"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Minha conta"),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text("TEKMEK", textAlign: TextAlign.center)),
            SearchAnchor(
              isFullScreen: true,
              searchController: controller,
              viewHintText: "Pesquise aqui...",
              viewTrailing: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(
                  onPressed: () {
                    controller.clear();
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
              builder: (context, controller) {
                return IconButton(
                  onPressed: () {
                    controller.openView();
                  },
                  icon: Icon(Icons.search),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  },
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Seja bem vindo, {nome}!",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            OutlinedButton(
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
              child: Row(children: [Text("Filtros")]),
            ),
          ],
        ),
      ),
    );
  }
}
