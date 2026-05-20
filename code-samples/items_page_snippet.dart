// Public showcase snippet extracted from NETech POS Items Page.
// Backend streams, auth/store resolution, and production item models removed.

import 'package:flutter/material.dart';

class ItemsPageSnippet extends StatefulWidget {
  const ItemsPageSnippet({super.key});

  @override
  State<ItemsPageSnippet> createState() => _ItemsPageSnippetState();
}

class _ItemsPageSnippetState extends State<ItemsPageSnippet> {
  final searchCtrl = TextEditingController();
  String query = '';

  final items = const [
    DemoItem(
      name: 'Chicken Rice',
      category: 'Rice',
      price: 5.00,
      imageUrl: null,
    ),
    DemoItem(
      name: 'CHICKENNN',
      category: 'CHICKENNN',
      price: 10.00,
      imageUrl: null,
    ),
    DemoItem(
      name: 'Chili Beans',
      category: 'Sides',
      price: 1.00,
      originalPrice: 3.00,
      imageUrl: null,
    ),
    DemoItem(
      name: 'Duck',
      category: 'Fillet',
      price: 8.00,
      originalPrice: 10.00,
      color: Color(0xFF10B981),
    ),
    DemoItem(
      name: 'Egg',
      category: '',
      price: 3.00,
      imageUrl: null,
    ),
    DemoItem(
      name: 'Fried Rice',
      category: '',
      price: 6.00,
      imageUrl: null,
    ),
  ];

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();

    final filtered = q.isEmpty
        ? items
        : items.where((item) {
            return item.name.toLowerCase().contains(q) ||
                item.category.toLowerCase().contains(q);
          }).toList();

    return Row(
      children: [
        SizedBox(
          width: 220,
          child: Container(
            color: const Color(0xFFF6F8FC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _SidebarItem(label: 'All Items', selected: true),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _SearchBar(
                  controller: searchCtrl,
                  query: query,
                  onChanged: (value) {
                    setState(() => query = value);
                  },
                  onClear: () {
                    searchCtrl.clear();
                    setState(() => query = '');
                  },
                ),
                const SizedBox(height: 10),
                const _InfoBanner(),
                const SizedBox(height: 12),
                Expanded(
                  child: _ItemsTable(items: filtered),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search all items',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (query.trim().isNotEmpty)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        border: Border.all(color: const Color(0xFFD7E3FF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.black54),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Showing active items available for this store. Items are managed in Backoffice.',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemsTable extends StatelessWidget {
  const _ItemsTable({required this.items});

  final List<DemoItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No matching items.',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFBFC9E5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                SizedBox(width: 48),
                Expanded(
                  child: Text(
                    'Name of item',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Price',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      _ItemVisual(item: item),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (item.category.trim().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: item.hasDiscount
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '\$${item.originalPrice!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 11,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemVisual extends StatelessWidget {
  const _ItemVisual({required this.item});

  final DemoItem item;

  @override
  Widget build(BuildContext context) {
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 28,
          height: 28,
          color: Colors.black12,
          child: Image.network(
            item.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.broken_image, size: 16);
            },
          ),
        ),
      );
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: item.color ?? const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.selected,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? const Color(0xFF2B4BCE) : Colors.white,
      padding: const EdgeInsets.all(16),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class DemoItem {
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final Color? color;

  const DemoItem({
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.color,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}
