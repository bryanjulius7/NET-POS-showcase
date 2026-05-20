// Public showcase snippet extracted from NETech POS Shift Management.
// Backend streams, Firestore writes, attendance checks, printer services,
// and production reconciliation logic removed.

import 'package:flutter/material.dart';

class ShiftManagementSnippet extends StatefulWidget {
  const ShiftManagementSnippet({super.key});

  @override
  State<ShiftManagementSnippet> createState() =>
      _ShiftManagementSnippetState();
}

class _ShiftManagementSnippetState extends State<ShiftManagementSnippet> {
  bool drawerOpen = false;
  int selectedTab = 0;

  final startingCashCtrl = TextEditingController(text: '0.00');

  final demoReport = ShiftReport(
    staffName: 'jermayne',
    storeName: 'Kovan',
    startedAt: '2026-05-20 17:11',
    endedAt: '2026-05-20 17:30',
    startingCash: 10.00,
    cashSales: 75.50,
    cashRefunds: 0.00,
    cashVoids: 0.00,
    paidIn: 0.00,
    paidOut: 0.00,
    actualCash: 100.00,
    grossSales: 159.00,
    refunds: 0.00,
    voids: 0.00,
    discounts: 0.00,
    netSales: 159.00,
  );

  double get expectedCash {
    return demoReport.startingCash +
        demoReport.cashSales -
        demoReport.cashRefunds -
        demoReport.cashVoids +
        demoReport.paidIn -
        demoReport.paidOut;
  }

  @override
  void dispose() {
    startingCashCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = selectedTab == 0
        ? drawerOpen
            ? _ActiveDrawerView(
                report: demoReport.copyWith(
                  actualCash: expectedCash,
                ),
                onEndDrawer: () {
                  setState(() => drawerOpen = false);
                },
              )
            : _StartDrawerView(
                controller: startingCashCtrl,
                onStartDrawer: () {
                  setState(() => drawerOpen = true);
                },
              )
        : const _DrawerHistoryView();

    return Row(
      children: [
        SizedBox(
          width: 220,
          child: _ShiftSidebar(
            selectedTab: selectedTab,
            onSelect: (index) => setState(() => selectedTab = index),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: content),
      ],
    );
  }
}

class _ShiftSidebar extends StatelessWidget {
  const _ShiftSidebar({
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
            label: 'Cash Drawer',
            selected: selectedTab == 0,
            onTap: () => onSelect(0),
          ),
          _SidebarItem(
            label: 'Drawer History',
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

class _StartDrawerView extends StatelessWidget {
  const _StartDrawerView({
    required this.controller,
    required this.onStartDrawer,
  });

  final TextEditingController controller;
  final VoidCallback onStartDrawer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              child: Row(
                children: [
                  const Text(
                    'Starting Cash',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  const Text('S\$'),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 140,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.right,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                onPressed: onStartDrawer,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD9E4FB),
                  foregroundColor: Colors.black87,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Start Drawer',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveDrawerView extends StatelessWidget {
  const _ActiveDrawerView({
    required this.report,
    required this.onEndDrawer,
  });

  final ShiftReport report;
  final VoidCallback onEndDrawer;

  @override
  Widget build(BuildContext context) {
    final expectedCash = report.expectedCash;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              _TopActionButton(label: 'End Drawer', onTap: onEndDrawer),
              const SizedBox(width: 12),
              _TopActionButton(label: 'Pay In', onTap: () {}),
              const SizedBox(width: 12),
              _TopActionButton(label: 'Pay Out', onTap: () {}),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: _DrawerReportCard(
                  title: report.storeName,
                  staffName: report.staffName,
                  status: 'OPEN',
                  startedAt: report.startedAt,
                  endedAt: null,
                  startingCash: report.startingCash,
                  cashSales: report.cashSales,
                  cashRefunds: report.cashRefunds,
                  cashVoids: report.cashVoids,
                  paidIn: report.paidIn,
                  paidOut: report.paidOut,
                  expectedCash: expectedCash,
                  actualCash: null,
                  grossSales: report.grossSales,
                  refunds: report.refunds,
                  voids: report.voids,
                  discounts: report.discounts,
                  netSales: report.netSales,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFEAEAEA),
            foregroundColor: const Color(0xFF2B4BCE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class _DrawerReportCard extends StatelessWidget {
  const _DrawerReportCard({
    required this.title,
    required this.staffName,
    required this.status,
    required this.startedAt,
    required this.endedAt,
    required this.startingCash,
    required this.cashSales,
    required this.cashRefunds,
    required this.cashVoids,
    required this.paidIn,
    required this.paidOut,
    required this.expectedCash,
    required this.actualCash,
    required this.grossSales,
    required this.refunds,
    required this.voids,
    required this.discounts,
    required this.netSales,
  });

  final String title;
  final String staffName;
  final String status;
  final String startedAt;
  final String? endedAt;

  final double startingCash;
  final double cashSales;
  final double cashRefunds;
  final double cashVoids;
  final double paidIn;
  final double paidOut;
  final double expectedCash;
  final double? actualCash;

  final double grossSales;
  final double refunds;
  final double voids;
  final double discounts;
  final double netSales;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFBFC9E5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: status == 'OPEN' ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'User: $staffName',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const Divider(height: 26),
            _MetricRow('Started', startedAt),
            if (endedAt != null) _MetricRow('Ended', endedAt!),
            _MetricRow('Starting Cash', _money(startingCash)),
            _MetricRow('Cash Sales', _money(cashSales)),
            _MetricRow('Cash Refunds', _money(cashRefunds)),
            _MetricRow('Cash Voids', _money(cashVoids)),
            _MetricRow('Paid In', _money(paidIn)),
            _MetricRow('Paid Out', _money(paidOut)),
            const Divider(height: 26),
            _MetricRow(
              'Expected Cash Amount',
              _money(expectedCash),
              bold: true,
            ),
            if (actualCash != null) ...[
              const Divider(height: 26),
              _MetricRow(
                'Actual Cash Amount',
                _money(actualCash!),
                bold: true,
              ),
            ],
            const Divider(height: 26),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sales Summary',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Divider(height: 26),
            _MetricRow('Gross Sales', _money(grossSales), bold: true),
            _MetricRow('Refunds', _money(refunds)),
            _MetricRow('Voids', _money(voids)),
            _MetricRow('Discounts', _money(discounts)),
            const Divider(height: 26),
            _MetricRow('Net Sales', _money(netSales), bold: true),
          ],
        ),
      ),
    );
  }
}

class _DrawerHistoryView extends StatelessWidget {
  const _DrawerHistoryView();

  @override
  Widget build(BuildContext context) {
    final history = [
      DrawerHistoryRow(
        opened: '11/04/2026',
        closed: '20/05/2026',
        staffId: 'DfF3L8VIXHQh3uk...',
        startingCash: 20,
        actualCash: 100,
      ),
      DrawerHistoryRow(
        opened: '10/04/2026',
        closed: '10/04/2026',
        staffId: 'DfF3L8VIXHQh3uk...',
        startingCash: 100,
        actualCash: 10,
      ),
      DrawerHistoryRow(
        opened: '09/04/2026',
        closed: '10/04/2026',
        staffId: 'DfF3L8VIXHQh3uk...',
        startingCash: 20,
        actualCash: 20,
      ),
    ];

    return Container(
      color: const Color(0xFFF6F8FC),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final row = history[i];

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFCBD2E1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Opened: ${row.opened}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Closed: ${row.closed}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            row.staffId,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _money(row.startingCash),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _money(row.actualCash),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: bold ? Colors.black87 : Colors.black54,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              color: bold ? Colors.black87 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class ShiftReport {
  final String staffName;
  final String storeName;
  final String startedAt;
  final String endedAt;

  final double startingCash;
  final double cashSales;
  final double cashRefunds;
  final double cashVoids;
  final double paidIn;
  final double paidOut;
  final double actualCash;

  final double grossSales;
  final double refunds;
  final double voids;
  final double discounts;
  final double netSales;

  const ShiftReport({
    required this.staffName,
    required this.storeName,
    required this.startedAt,
    required this.endedAt,
    required this.startingCash,
    required this.cashSales,
    required this.cashRefunds,
    required this.cashVoids,
    required this.paidIn,
    required this.paidOut,
    required this.actualCash,
    required this.grossSales,
    required this.refunds,
    required this.voids,
    required this.discounts,
    required this.netSales,
  });

  double get expectedCash {
    return startingCash + cashSales - cashRefunds - cashVoids + paidIn - paidOut;
  }

  ShiftReport copyWith({
    double? actualCash,
  }) {
    return ShiftReport(
      staffName: staffName,
      storeName: storeName,
      startedAt: startedAt,
      endedAt: endedAt,
      startingCash: startingCash,
      cashSales: cashSales,
      cashRefunds: cashRefunds,
      cashVoids: cashVoids,
      paidIn: paidIn,
      paidOut: paidOut,
      actualCash: actualCash ?? this.actualCash,
      grossSales: grossSales,
      refunds: refunds,
      voids: voids,
      discounts: discounts,
      netSales: netSales,
    );
  }
}

class DrawerHistoryRow {
  final String opened;
  final String closed;
  final String staffId;
  final double startingCash;
  final double actualCash;

  const DrawerHistoryRow({
    required this.opened,
    required this.closed,
    required this.staffId,
    required this.startingCash,
    required this.actualCash,
  });
}

String _money(num v) => 'S\$${v.toStringAsFixed(2)}';
