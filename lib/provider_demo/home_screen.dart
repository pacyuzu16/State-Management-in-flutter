// ─────────────────────────────────────────────────────────────────────────────
// STEPS 4, 5 & 6:
//   Step 4 — Accessing the State   → context.watch<CounterModel>()
//   Step 5 — Updating the State    → context.read<CounterModel>().method()
//   Step 6 — How UI Rebuild Happens → Consumer<CounterModel> + notifyListeners
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ─────────────────────────────────────────────────────────────────────────
    // STEP 4: Accessing the State
    //
    // context.watch<T>() — reads state AND subscribes to changes.
    // This widget rebuilds every time CounterModel calls notifyListeners().
    //
    // Alternative: Provider.of<CounterModel>(context)  — same behavior
    // ─────────────────────────────────────────────────────────────────────────
    final counter = context.watch<CounterModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2d2d7a),
        title: const Text(
          'Provider Demo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Step Label ──────────────────────────────────────────────────
            _StepCard(
              step: 'Step 4 — Accessing State',
              description:
                  'context.watch<CounterModel>() reads the current count '
                  'and subscribes this widget to future changes.',
              code: 'final counter = context.watch<CounterModel>();',
            ),

            const SizedBox(height: 20),

            // ── STEP 6: UI Rebuild — Consumer wraps only what needs rebuilding
            // ─────────────────────────────────────────────────────────────────
            // STEP 6: How UI Rebuild Happens
            //
            // When increment/decrement is called:
            //   1. The method changes _count
            //   2. notifyListeners() fires
            //   3. Provider marks widgets using context.watch() as dirty
            //   4. Flutter rebuilds ONLY those widgets
            //
            // Consumer<T> is an optimization — it limits rebuilds to just
            // the builder subtree, not the whole HomeScreen.build().
            // ─────────────────────────────────────────────────────────────────
            Consumer<CounterModel>(
              builder: (context, counterModel, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Current Count',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${counterModel.count}',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2d2d7a),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFe8e8f8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Step 6 — Consumer rebuilds only this widget',
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFF4a4a8a)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── STEP 5: Updating the State ───────────────────────────────────
            // context.read<T>() — calls a method WITHOUT subscribing to rebuilds
            // Use this inside callbacks (onPressed, onTap) — never in build()
            // ─────────────────────────────────────────────────────────────────
            _StepCard(
              step: 'Step 5 — Updating State',
              description:
                  'context.read<T>() is used inside callbacks to call methods '
                  'on the model. It does NOT rebuild the widget itself.',
              code:
                  'onPressed: () => context.read<CounterModel>().increment()',
            ),

            const SizedBox(height: 20),

            // ── Action Buttons ───────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  label: '−',
                  color: Colors.redAccent,
                  // STEP 5: context.read — triggers state update, no rebuild here
                  onPressed: () => context.read<CounterModel>().decrement(),
                ),
                _ActionButton(
                  label: 'Reset',
                  color: Colors.grey,
                  onPressed: () => context.read<CounterModel>().reset(),
                ),
                _ActionButton(
                  label: '+',
                  color: const Color(0xFF2d2d7a),
                  onPressed: () => context.read<CounterModel>().increment(),
                ),
              ],
            ),

            const Spacer(),

            // ── Watch vs Read summary ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: const Text(
                '💡  context.watch<T>()  →  read + subscribe (use in build)\n'
                '💡  context.read<T>()   →  call methods only (use in callbacks)\n'
                '💡  Consumer<T>         →  rebuild only a specific subtree',
                style: TextStyle(fontSize: 12, height: 1.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  final String step;
  final String description;
  final String code;

  const _StepCard({
    required this.step,
    required this.description,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFccccdd)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d2d7a),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(description,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF333366),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(90, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle:
            const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      child: Text(label),
    );
  }
}
