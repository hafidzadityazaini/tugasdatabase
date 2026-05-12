import 'package:database/database.dart';
import 'package:database/productmodel.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final db = DatabaseIn();
  List<ContactModel> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await db.getAll();
    setState(() {
      data = result;
    });
  }

  // 🔹 FORM TAMBAH DATA
  void showAddDialog() {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final emailC = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Tambah Data"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: phoneC,
                  decoration: const InputDecoration(labelText: "No Telepon"),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailC,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameC.text.isEmpty || phoneC.text.isEmpty) return;

                await db.insert(
                  ContactModel(
                    name: nameC.text,
                    phone: phoneC.text,
                    email: emailC.text,
                  ),
                );

                Navigator.pop(dialogContext);
                await loadData();
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // 🔹 FORM EDIT DATA
  void showEditDialog(ContactModel item) {
    final nameC = TextEditingController(text: item.name);
    final phoneC = TextEditingController(text: item.phone);
    final emailC = TextEditingController(text: item.email);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Data"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: phoneC,
                  decoration: const InputDecoration(labelText: "No Telepon"),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailC,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (item.id == null) return;

                await db.update(
                  ContactModel(
                    id: item.id,
                    name: nameC.text,
                    phone: phoneC.text,
                    email: emailC.text,
                  ),
                );

                Navigator.pop(dialogContext);
                await loadData();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // 🔹 HAPUS DATA
  void deleteData(int id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Hapus Data"),
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                await db.delete(id);
                Navigator.pop(dialogContext);
                await loadData();
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Database Sederhana")),

      body: data.isEmpty
          ? const Center(child: Text("Data kosong"))
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(item.name ?? ''),
                    subtitle: Text(item.phone ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showEditDialog(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (item.id != null) {
                              deleteData(item.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}