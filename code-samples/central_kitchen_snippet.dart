// Public showcase snippet extracted from NETech POS Central Kitchen Ordering.
// Backend streams, Firestore writes, auth/store resolution, and production routing removed.

import 'package:flutter/material.dart';

class CentralKitchenSnippet extends StatefulWidget {
  const CentralKitchenSnippet({super.key});

  @override
  State<CentralKitchenSnippet> createState() => _CentralKitchenSnippetState();
}

class _CentralKitchenSnippetState extends State<CentralKitchenSnippet> {
  int selectedTab = 0;
  final searchCtrl = TextEditingController();

  final items = [
    KitchenItem(id: '1', name: 'Chili'),
    KitchenItem(id: '2', name: 'Ginger'),
    KitchenItem(id: '3', name: 'Packets'),
    KitchenItem(id: '4', name: 'Utensils'),
  ];

  final qty = <String, int>{};
  bool showConfirm = false;

  int get itemsSelected => qty.values.where((v) => v > 0).length;
  int get totalQty => qty.values.fold(0, (a, b) => a + b);

  List<KitchenOrderLine> get selectedLines {
    return items
        .where((item) => (qty[item.id] ?? 0) > 0)
        .map((item) => KitchenOrderLine(
              name: item.name,
              qty: qty[item.id] ?? 0,
            ))
        .toList();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = selectedTab == 0
        ? showConfirm
            ? _ConfirmOrderView(
                lines: selectedLines,
                onBack: () => setState(() => showConfirm = false),
                onPlaceOrder: () {
                  setState(() {
                    qty.clear();
                    showConfirm = false;
                    selectedTab = 1;
                  });
                },
              )
            : _OrderView(
                items: items,
                qty: qty,
                itemsSelected: itemsSelected,
                totalQty: totalQty,
                searchCtrl: searchCtrl,
                onIncrement: (id) {
                  setState(() => qty[id] = (qty[id] ?? 0) + 1);
                },
                onDecrement: (id) {
                  setState(() {
                    final current = qty[id] ?? 0;
                    if (current <= 1) {
                      qty.remove(id);
                    } else {
                      qty[id] = current - 1;
                    }
                  });
                },
                onClear: () => setState(qty.clear),
                onConfirm: itemsSelected == 0
                    ? null
                    : () => setState(() => showConfirm = true),
              )
        : const _RequestedOrdersView();

    return Row(
      children: [
        SizedBox(
          width: 220,
          child: _KitchenSidebar(
            selectedTab: selectedTab,
            onSelect: (index) {
              setState(() {
                selectedTab = index;
                showConfirm = false;
              });
            },
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: content),
      ],
    );
  }
}

class _KitchenSidebar extends StatelessWidget {
  const _KitchenSidebar({
    required this.selectedTab,
    required this.onSelect,
  });

  final int selectedTab;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F8FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarItem(
            label: 'Order',
            selected: selectedTab == 0,
            onTap: () => onSelect(0),
          ),
          _SidebarItem(
            label: 'Requested',
            selected: selectedTab == 1,
            onTap: () => onSelect(1),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF2B4BCE) : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderView extends StatelessWidget {
  const _OrderView({
    required this.items,
    required this.qty,
    required this.itemsSelected,
    required this.totalQty,
    required this.searchCtrl,
    required this.onIncrement,
    required this.onDecrement,
    required this.onClear,
    required this.onConfirm,
  });

  final List<KitchenItem> items;
  final Map<String, int> qty;
  final int itemsSelected;
  final int totalQty;
  final TextEditingController searchCtrl;

  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final VoidCallback onClear;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Items Selected: $itemsSelected  •  Total Qty: $totalQty',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: itemsSelected == 0 ? null : onClear,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search item',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
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
                            Expanded(
                              child: Text(
                                'Item',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.w900),
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
                          itemBuilder: (context, i) {
                            final item = items[i];
                            final currentQty = qty[item.id] ?? 0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: _QtyStepper(
                                      value: currentQty,
                                      onMinus: () => onDecrement(item.id),
                                      onPlus: () => onIncrement(item.id),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: onConfirm,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2B4BCE),
                            ),
                            child: const Text(
                              'Confirm Order',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _ConfirmOrderView extends StatelessWidget {
  const _ConfirmOrderView({
    required this.lines,
    required this.onBack,
    required this.onPlaceOrder,
  });

  final List<KitchenOrderLine> lines;
  final VoidCallback onBack;
  final VoidCallback onPlaceOrder;

  int get totalQty => lines.fold(0, (sum, line) => sum + line.qty);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFBFC9E5)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 3),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Confirm Order',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Item',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Quantity',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            for (final line in lines) ...[
              Row(
                children: [
                  Expanded(child: Text(line.name)),
                  SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${line.qty}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 22),
            ],
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Quantity',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$totalQty',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: onBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 160,
                  height: 44,
                  child: FilledButton(
                    onPressed: onPlaceOrder,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4BCE),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestedOrdersView extends StatelessWidget {
  const _RequestedOrdersView();

  @override
  Widget build(BuildContext context) {
    final orders = [
      KitchenOrder(
        date: '10 Apr 2026, 12:50 PM',
        itemCount: 2,
        totalQty: 2,
        status: 'Confirmed',
      ),
      KitchenOrder(
        date: '9 Apr 2026, 9:57 PM',
        itemCount: 2,
        totalQty: 2,
        status: 'Requested',
      ),
      KitchenOrder(
        date: '4 Apr 2026, 12:25 PM',
        itemCount: 2,
        totalQty: 2,
        status: 'Rejected',
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFBFC9E5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Orders Placed',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final order = orders[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.date,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${order.itemCount} items • Total qty: ${order.totalQty}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _StatusChip(status: order.status),
                          const SizedBox(width: 14),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: value <= 0 ? null : onMinus,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 28,
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  Color get color {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF18C964);
      case 'rejected':
        return const Color(0xFFFF3B30);
      case 'requested':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class KitchenItem {
  final String id;
  final String name;

  const KitchenItem({
    required this.id,
    required this.name,
  });
}

class KitchenOrderLine {
  final String name;
  final int qty;

  const KitchenOrderLine({
    required this.name,
    required this.qty,
  });
}

class KitchenOrder {
  final String date;
  final int itemCount;
  final int totalQty;
  final String status;

  const KitchenOrder({
    required this.date,
    required this.itemCount,
    required this.totalQty,
    required this.status,
  });
}
