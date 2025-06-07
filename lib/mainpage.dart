import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manifest/addclass_popup.dart';
import 'package:manifest/class_box.dart';
import 'package:manifest/class_model.dart';
import 'package:manifest/class_repo.dart';
import 'package:manifest/isconsumable_slider.dart';

class ManifestPage extends StatefulWidget {
  final String title;
  const ManifestPage({super.key, required this.title});

  @override
  State<ManifestPage> createState() => _ManifestPageState();
}

class _ManifestPageState extends State<ManifestPage> {
  final ClassRepo classRepo = ClassRepo();
  List<Class> classes = [];
  bool isLoading = false;
  bool isConsumable = true;

  // Function to fetch classes from Supabase
  Future<void> fetchClasses({bool isConsumable = true}) async {
    setState(() => isLoading = true); // Start loading
    classes = await classRepo.fetchClasses(isConsumable: isConsumable);
    setState(() => isLoading = false); // End loading
  }

  @override
  void initState() {
    fetchClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () async {
          final dynamic response;
          response = await addClassPopup(context);
          if (response != null) classRepo.addClass(response);
          fetchClasses(isConsumable: isConsumable);
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        // actions: [
        //   IconButton.filled(
        //       style: IconButton.styleFrom(
        //           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //           foregroundColor: Theme.of(context).colorScheme.primary,
        //           shape: const RoundedRectangleBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(12)))),
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.add,
        //       ))
        // ],
        centerTitle: true,
        toolbarHeight: 40,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              IsconsumableSlider(
                isConsumable: isConsumable,
                onToggle: (bool value) {
                  setState(() {
                    isConsumable = value;
                  });
                  fetchClasses(isConsumable: isConsumable);
                },
              ),
              Expanded(
                child: classes.isEmpty
                    ? isLoading
                        ? const Center(
                            child: SizedBox(
                                child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator.adaptive(),
                          ))) // Loading state
                        : const Text("No classes available") // No data state
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: classes.length,
                          itemBuilder: (context, index) {
                            return classBox(
                                name: classes[index].name,
                                url: classes[index].imageUrl,
                                context: context);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
