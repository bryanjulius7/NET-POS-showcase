// Public showcase snippet extracted from NETech POS Checkout.
// Production backend, receipt creation, payment, printer, and security logic removed.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CheckoutPageSnippet extends StatefulWidget {
  const CheckoutPageSnippet({super.key});

  @override
  State<CheckoutPageSnippet> createState() => _CheckoutPageSnippetState();
}

class _CheckoutPageSnippetState extends State<CheckoutPageSnippet> {
  final List<_DemoItem> items = [
    _DemoItem(id: '1', name: 'Chicken Rice', price: 4.50, color: Colors.orange),
    _DemoItem(id: '2', name: 'Kopi', price: 1.60, color: Colors.brown),
    _DemoItem(id: '3', name: 'Noodles', price: 5.00, color: Colors.redAccent),
    _DemoItem(id: '4', name: 'Tea', price: 1.40, color: Colors.green),
  ];

  final Map<String, int> cart = {};
  bool editMode = false;

  double get total {
    return cart.entries.fold(0, (sum, entry) {
      final item = items.firstWhere((i) => i.id == entry.key);
      return sum + item.price * entry.value;
    });
  }

  void addItem(_DemoItem item) {
    setState(() {
      cart[item.id] = (cart[item.id] ?? 0) + 1;
    });
  }

  void removeItem(_DemoItem item) {
    setState(() {
      final qty = cart[item.id] ?? 0;
      if (qty <= 1) {
        cart.remove(item.id);
      } else {
        cart[item.id] = qty - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 900;

        final grid = _ItemGrid(
          items: items,
          cart: cart,
          editMode: editMode,
          onToggleEdit: () => setState(() => editMode = !editMode),
          onAddItem: addItem,
        );

        final order = _OrderPanel(
          items: items,
          cart: cart,
          total: total,
          onAdd: addItem,
          onRemove: removeItem,
          onClear: () => setState(cart.clear),
        );

        if (!isWide) {
          return Column(
            children: [
              Expanded(child: grid),
              const SizedBox(height: 8),
              SizedBox(height: 360, child: order),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 7, child: grid),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: order),
          ],
        );
      },
    );
  }
}

class _ItemGrid extends StatelessWidget {
  const _ItemGrid({
    required this.items,
    required this.cart,
    required this.editMode,
    required this.onToggleEdit,
    required this.onAddItem,
  });

  final List<_DemoItem> items;
  final Map<String, int> cart;
  final bool editMode;
  final VoidCallback onToggleEdit;
  final ValueChanged<_DemoItem> onAddItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Checkout Grid',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: onToggleEdit,
              icon: Icon(editMode ? Icons.check_circle : Icons.edit_outlined),
              label: Text(editMode ? 'Done Editing' : 'Edit Grid'),
            ),
          ],
        ),
        if (editMode)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: const Text(
              'Edit mode: tap or drag tiles to customise the checkout layout.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        Expanded(
          child: GridView.builder(
            itemCount: 16,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final item = index < items.length ? items[index] : null;

              if (item == null) {
                return _EmptyGridTile(editMode: editMode);
              }

              return _ItemTile(
                item: item,
                qty: cart[item.id] ?? 0,
                editMode: editMode,
                onTap: () {
                  if (!editMode) onAddItem(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderPanel extends StatelessWidget {
  const _OrderPanel({
    required this.items,
    required this.cart,
    required this.total,
    required this.onAdd,
    required this.onRemove,
    required this.onClear,
  });

  final List<_DemoItem> items;
  final Map<String, int> cart;
  final double total;
  final ValueChanged<_DemoItem> onAdd;
  final ValueChanged<_DemoItem> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final cartLines =
        cart.entries.map((entry) {
          final item = items.firstWhere((i) => i.id == entry.key);
          return (item: item, qty: entry.value);
        }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x08000000))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                const Text(
                  'Order',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const Spacer(),
                TextButton(
                  onPressed: cart.isEmpty ? null : onClear,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: cartLines.isEmpty
                ? const Center(child: Text('Tap an item to add it here.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: cartLines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final line = cartLines[i];
                      final lineTotal = line.item.price * line.qty;

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                          color: const Color(0xFFFCFCFD),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    line.item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${lineTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '\$${line.item.price.toStringAsFixed(2)} each',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                _QtyButton(
                                  icon: Icons.remove,
                                  onPressed: () => onRemove(line.item),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '${line.qty}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                _QtyButton(
                                  icon: Icons.add,
                                  onPressed: () => onAdd(line.item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: FilledButton(
                    onPressed: cart.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Proceeding to payment...'),
                              ),
                            );
                          },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.qty,
    required this.editMode,
    required this.onTap,
  });

  final _DemoItem item;
  final int qty;
  final bool editMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final soldOutToday = item.dailyLimit != null && qty >= item.dailyLimit!;
    final remaining = item.dailyLimit == null
        ? null
        : math.max(0, item.dailyLimit! - qty);

    return Opacity(
      opacity: soldOutToday && !editMode ? 0.58 : 1,
      child: Material(
        color: editMode ? const Color(0xFFFFFBEB) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: soldOutToday ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: editMode
                    ? const Color(0xFFF59E0B)
                    : soldOutToday
                        ? Colors.red.shade300
                        : Colors.black12,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    if (remaining != null)
                      Text(
                        soldOutToday ? 'Sold out today' : '$remaining left today',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: soldOutToday ? Colors.red : Colors.black54,
                        ),
                      ),
                  ],
                ),
                if (qty > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 12,
                      child: Text('$qty'),
                    ),
                  ),
                if (editMode)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.open_with, size: 14),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyGridTile extends StatelessWidget {
  const _EmptyGridTile({required this.editMode});

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: editMode ? const Color(0xFFF8FAFC) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: editMode
            ? const Text(
                'Assign Item',
                style: TextStyle(fontWeight: FontWeight.w700),
              )
            : const Icon(Icons.grid_view_rounded, color: Colors.black26),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _DemoItem {
  final String id;
  final String name;
  final double price;
  final Color color;
  final int? dailyLimit;

  const _DemoItem({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    this.dailyLimit = 5,
  });
}
