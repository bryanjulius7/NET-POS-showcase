// Public showcase snippet extracted from NETech POS Transactions.
// Backend queries, refund execution, printer services,
// polling logic, and Firestore integrations removed.

import 'package:flutter/material.dart';

class TransactionsShowcasePage extends StatefulWidget {
  const TransactionsShowcasePage({super.key});

  @override
  State<TransactionsShowcasePage> createState() =>
      _TransactionsShowcasePageState();
}

class _TransactionsShowcasePageState
    extends State<TransactionsShowcasePage> {
  final searchCtrl = TextEditingController();

  String query = '';

  final receipts = [
    DemoReceipt(
      id: '1',
      receiptNo: 'WEREW-000299',
      total: 16.50,
      date: '20/05/26 13:35',
      paymentSummary: 'CASH \$16.50',
      items: [
        DemoLine(
          name: 'Roasted Chicken Rice (Large)',
          qty: 1,
          unitPrice: 7.00,
        ),
        DemoLine(
          name: 'Spinach',
          qty: 1,
          unitPrice: 2.50,
        ),
        DemoLine(
          name: 'Hainanese Chicken Rice (Large)',
          qty: 1,
          unitPrice: 3.00,
        ),
        DemoLine(
          name: 'Tofu',
          qty: 1,
          unitPrice: 4.00,
        ),
      ],
    ),
    DemoReceipt(
      id: '2',
      receiptNo: 'WEREW-000298',
      total: 13.00,
      date: '17/04/26 19:06',
      paymentSummary: 'CARD \$13.00',
      refunded: true,
      items: [
        DemoLine(
          name: 'Noodles',
          qty: 2,
          unitPrice: 6.50,
        ),
      ],
    ),
  ];

  String selectedId = '1';

  DemoReceipt get selected =>
      receipts.firstWhere((r) => r.id == selectedId);

  @override
  void initState() {
    super.initState();

    searchCtrl.addListener(() {
      setState(() {
        query = searchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        query.isEmpty
            ? receipts
            : receipts.where((r) {
              return r.receiptNo
                  .toLowerCase()
                  .contains(query);
            }).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 1020;

        final left = _TransactionsPane(
          receipts: filtered,
          selectedId: selectedId,
          searchCtrl: searchCtrl,
          onSelect: (id) {
            setState(() => selectedId = id);
          },
        );

        final right = _ReceiptPane(receipt: selected);

        if (!isWide) {
          return Column(
            children: [
              SizedBox(height: 320, child: left),
              const Divider(height: 1),
              Expanded(child: right),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(width: 360, child: left),
            const VerticalDivider(width: 1),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _TransactionsPane extends StatelessWidget {
  const _TransactionsPane({
    required this.receipts,
    required this.selectedId,
    required this.searchCtrl,
    required this.onSelect,
  });

  final List<DemoReceipt> receipts;
  final String selectedId;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFD),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${receipts.length} receipts',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search receipt no...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: receipts.length,
              separatorBuilder:
                  (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final r = receipts[i];

                return _ReceiptTile(
                  receipt: r,
                  selected: r.id == selectedId,
                  onTap: () => onSelect(r.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({
    required this.receipt,
    required this.selected,
    required this.onTap,
  });

  final DemoReceipt receipt;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg =
        selected
            ? const Color(0xFFEFF4FF)
            : Colors.white;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected
                      ? const Color(0xFF2B4BCE)
                      : Colors.black12,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              if (selected)
                Container(
                  width: 4,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B4BCE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              if (selected) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            receipt.receiptNo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          _fmtMoney(receipt.total),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color:
                                receipt.refunded
                                    ? Colors.red.shade700
                                    : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            receipt.date,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (receipt.refunded)
                          const _RefundChip(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptPane extends StatelessWidget {
  const _ReceiptPane({required this.receipt});

  final DemoReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Reprint'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Void'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Issue Refund'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _fmtMoney(receipt.total),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color:
                              receipt.refunded
                                  ? Colors.red.shade700
                                  : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Total Sale',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (receipt.refunded) ...[
                        const SizedBox(height: 10),
                        const _RefundChip(),
                      ],
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: receipt.items.length,
                          separatorBuilder:
                              (_, __) =>
                                  const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final item =
                                receipt.items[i];

                            return Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        item.name,
                                        style:
                                            const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .w800,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${item.qty} × ${_fmtMoney(item.unitPrice)}',
                                        style:
                                            const TextStyle(
                                              color:
                                                  Colors
                                                      .black54,
                                              fontSize:
                                                  12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _fmtMoney(
                                    item.qty *
                                        item.unitPrice,
                                  ),
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _fmtMoney(receipt.total),
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius:
                              BorderRadius.circular(12),
                          color: const Color(0xFFFAFBFF),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Payment',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                receipt.paymentSummary,
                                style: const TextStyle(
                                  color:
                                      Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  'Kovan',
                                  style: TextStyle(
                                    color:
                                        Colors.black45,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  receipt.receiptNo,
                                  style: const TextStyle(
                                    color:
                                        Colors.black45,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            receipt.date,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundChip extends StatelessWidget {
  const _RefundChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.red.withOpacity(0.30),
        ),
      ),
      child: const Text(
        'REFUNDED',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class DemoReceipt {
  final String id;
  final String receiptNo;
  final double total;
  final String date;
  final bool refunded;
  final String paymentSummary;
  final List<DemoLine> items;

  DemoReceipt({
    required this.id,
    required this.receiptNo,
    required this.total,
    required this.date,
    required this.paymentSummary,
    required this.items,
    this.refunded = false,
  });
}

class DemoLine {
  final String name;
  final int qty;
  final double unitPrice;

  DemoLine({
    required this.name,
    required this.qty,
    required this.unitPrice,
  });
}

String _fmtMoney(num v) {
  return '\$${v.toStringAsFixed(2)}';
}
