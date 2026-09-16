import 'package:flutter/material.dart';

class CafeFilterBottomSheet extends StatefulWidget {
  const CafeFilterBottomSheet({super.key});

  @override
  State<CafeFilterBottomSheet> createState() => _CafeFilterBottomSheetState();
}

class _CafeFilterBottomSheetState extends State<CafeFilterBottomSheet> {
  int selectedTabIndex = 0; // 0 for Type, 1 for Price
  final List<String> types = [
    'Bun Maska', 'Buttermilk', 'Cakes', 'Chaat', 'Cold Drinks', 'Cooler', 'Croissant', 'Gravy', 'Maggi', 'Puff', 'Rolls', 'Sandwich'
  ];
  final Set<String> selectedTypes = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar
                Container(
                  width: 120,
                  color: Colors.grey.shade50,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildSidebarItem('Type', 0),
                      _buildSidebarItem('Price', 1),
                    ],
                  ),
                ),
                // Right Content Area
                Expanded(
                  child: selectedTabIndex == 0 ? _buildTypeFilters() : _buildPriceFilters(),
                ),
              ],
            ),
          ),
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedTypes.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Clear all', style: TextStyle(color: Color(0xFFF0145A), fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0145A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Show 29 products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, int index) {
    bool isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        color: isSelected ? Colors.purple.shade50 : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilters() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        final isSelected = selectedTypes.contains(type);
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedTypes.remove(type);
              } else {
                selectedTypes.add(type);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type, style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? const Color(0xFFF0145A) : Colors.grey.shade300, width: isSelected ? 6 : 1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceFilters() {
    return const Center(child: Text('Price filters coming soon', style: TextStyle(color: Colors.grey)));
  }
}
