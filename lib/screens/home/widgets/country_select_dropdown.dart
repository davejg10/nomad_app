import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/screens/home/providers/all_countries_provider.dart';
import 'package:nomad/screens/home/providers/selected_countries_provider.dart';

class CountrySelectDropdown extends ConsumerWidget {
  const CountrySelectDropdown({
    super.key,
    required this.controller
  });

  final MultiSelectController<Neo4jCountry> controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiDropdown<Neo4jCountry>.future(
      future: () async {
        Set<Neo4jCountry> selectedCountries = ref.read(selectedCountryListProvider);
        Set<Neo4jCountry> allCountries = await ref.read(allCountriesProvider.future);
        return allCountries.map((country) => DropdownItem(
          label: country.getName,
          value: country,
          selected: selectedCountries.contains(country)
        )).toList();
      },
      itemBuilder: (item, index, onTap) {
        bool isSelected = controller.selectedItems.contains(item);
        return ListTile(
          leading: Image.asset('assets/flags/${item.value.getName.toLowerCase()}.png', width: 25, height: 25,),
          title: Text(item.value.getName),
          trailing: isSelected ? Icon(Icons.check_box, color: Colors.green) : Icon(Icons.check_box_outline_blank) ,
          onTap: onTap,
        );

      },
      controller: controller,
      enabled: true,
      chipDecoration: const ChipDecoration(
        backgroundColor: Colors.yellow,
        wrap: true,
        runSpacing: 2,
        spacing: 10,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'Where to next?',
        hintStyle: const TextStyle(color: Colors.black87),
        prefixIcon: const Icon(CupertinoIcons.flag),
        showClearIcon: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black87,
          ),
        ),
      ),
      dropdownDecoration: const DropdownDecoration(
        marginTop: 2,
        maxHeight: 500,
        header: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Select countries from the list',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedIcon:
        const Icon(Icons.check_box, color: Colors.green),
        disabledIcon:
        Icon(Icons.lock, color: Colors.grey.shade300),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select at least one country';
        }
        return null;
      }
    );
  }
}
