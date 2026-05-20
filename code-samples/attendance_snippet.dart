// Public showcase snippet extracted from NETech POS Attendance.
// Backend attendance repo, Firestore, camera capture, and auth logic removed.

import 'package:flutter/material.dart';

class AttendanceSnippet extends StatefulWidget {
  const AttendanceSnippet({super.key});

  @override
  State<AttendanceSnippet> createState() => _AttendanceSnippetState();
}

class _AttendanceSnippetState extends State<AttendanceSnippet> {
  final openSessions = [
    AttendanceSession(name: 'jermayne', clockedInAt: '17/04/26 19:11'),
    AttendanceSession(name: 'Bryan', clockedInAt: '10/04/26 12:57'),
  ];

  void openPinFlow(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AttendancePinPage(
          title: title,
          onConfirmed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AttendanceConfirmPageSnippet(
                  staffName: 'Bryan',
                  type: title,
                  at: DateTime.now(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B4BCE),
        foregroundColor: Colors.white,
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DeviceSessionCard(
                  company: 'NE001',
                  store: 'Kovan',
                  deviceUser: 'jermayne',
                  sessions: openSessions,
                  onClockOut: () => openPinFlow('Clock Out'),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: () => openPinFlow('Clock In'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4BCE),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Clock In',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'To Clock Out: tap your name in the Clocked In list.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceSessionCard extends StatelessWidget {
  const _DeviceSessionCard({
    required this.company,
    required this.store,
    required this.deviceUser,
    required this.sessions,
    required this.onClockOut,
  });

  final String company;
  final String store;
  final String deviceUser;
  final List<AttendanceSession> sessions;
  final VoidCallback onClockOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD2E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEVICE SESSION',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
          ),
          const SizedBox(height: 10),
          _RowKV('Company', company),
          _RowKV('Store', store),
          _RowKV('Device User', deviceUser),
          const Divider(height: 24),
          const Text(
            'CLOCKED IN (OPEN SESSIONS)',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
          ),
          const SizedBox(height: 10),
          for (final session in sessions)
            InkWell(
              onTap: onClockOut,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD2E1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Clocked in at ${session.clockedInAt}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.logout, color: Colors.black54),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AttendancePinPage extends StatefulWidget {
  const AttendancePinPage({
    super.key,
    required this.title,
    required this.onConfirmed,
  });

  final String title;
  final VoidCallback onConfirmed;

  @override
  State<AttendancePinPage> createState() => _AttendancePinPageState();
}

class _AttendancePinPageState extends State<AttendancePinPage> {
  final pinCtrl = TextEditingController();
  String? error;

  @override
  void dispose() {
    pinCtrl.dispose();
    super.dispose();
  }

  void submit() {
    if (pinCtrl.text.trim().length != 4) {
      setState(() => error = 'Please enter a 4-digit PIN.');
      return;
    }

    widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B4BCE),
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFBFC9E5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter 4-digit PIN',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: pinCtrl,
                  obscureText: true,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton(
                    onPressed: submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4BCE),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceConfirmPageSnippet extends StatelessWidget {
  const AttendanceConfirmPageSnippet({
    super.key,
    required this.staffName,
    required this.type,
    required this.at,
  });

  final String staffName;
  final String type;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B4BCE),
        foregroundColor: Colors.white,
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  staffName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  type.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  _fmt(at),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4BCE),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Go to POS',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fmt(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d  $hh:$mm';
  }
}

class _RowKV extends StatelessWidget {
  const _RowKV(this.k, this.v);

  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            v,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceSession {
  final String name;
  final String clockedInAt;

  const AttendanceSession({
    required this.name,
    required this.clockedInAt,
  });
}
