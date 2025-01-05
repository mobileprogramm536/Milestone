import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CountrySelectionModal extends StatelessWidget {
  final List<Map<String, dynamic>> countries;
  final Function(Map<String, dynamic>) onCountrySelected;
  final Map<String, Color> highlightedCountries;

  const CountrySelectionModal({
    Key? key,
    required this.countries,
    required this.onCountrySelected,
    required this.highlightedCountries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.darkgrey1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select a Country',
              style: TextStyle(
                color: AppColors.white1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  final countryCode = country['code'] ?? '';
                  final countryName = country['name'] ?? 'Unknown';
                  final isVisited =
                      highlightedCountries.containsKey(countryCode);

                  return ListTile(
                    title: Text(
                      countryName,
                      style: const TextStyle(color: AppColors.white1),
                    ),
                    trailing: isVisited
                        ? const Icon(Icons.check, color: AppColors.green1)
                        : null, // Green check sign for visited countries
                    onTap: () {
                      Navigator.of(context).pop(); // Close the modal
                      onCountrySelected(
                          country); // Pass the selected country back
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
