import 'package:flutter/material.dart';

import '../../data/models/workout_session.dart';
import 'inline_field.dart';

const _setTypeCycle = ['working', 'warmup', 'dropset', 'failure', 'assisted'];

String _setTypeLabel(String type) {
  switch (type) {
    case 'warmup':
      return 'W';
    case 'dropset':
      return 'D';
    case 'failure':
      return 'F';
    case 'assisted':
      return 'A';
    default:
      return '';
  }
}

Color _setTypeColor(String type) {
  switch (type) {
    case 'warmup':
      return const Color(0xFF6B7280);
    case 'dropset':
      return const Color(0xFF7C3AED);
    case 'failure':
      return const Color(0xFFDC2626);
    case 'assisted':
      return const Color(0xFF2563EB);
    default:
      return const Color(0xFFB45309);
  }
}

String _typeDisplayName(String type) {
  switch (type) {
    case 'warmup':
      return 'Warmup';
    case 'dropset':
      return 'Drop set';
    case 'failure':
      return 'Failure';
    case 'assisted':
      return 'Assisted';
    default:
      return 'Working set';
  }
}

class SetTable extends StatelessWidget {
  const SetTable({
    super.key,
    required this.exercise,
    required this.isMutating,
    required this.onAddSet,
    required this.onLogSet,
    required this.onToggleSet,
    required this.onCycleSetType,
    required this.onRemoveSet,
  });

  final WorkoutExercise exercise;
  final bool isMutating;
  final VoidCallback onAddSet;
  final void Function(double? weightKg, int? reps, WorkoutSet set) onLogSet;
  final void Function(WorkoutSet set) onToggleSet;
  final void Function(String type, WorkoutSet set) onCycleSetType;
  final void Function(WorkoutSet set) onRemoveSet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TableHeader(),
        const SizedBox(height: 4),
        ...exercise.sets.asMap().entries.map(
              (entry) => _SetRow(
                index: entry.key + 1,
                set: entry.value,
                isMutating: isMutating,
                onLog: (weight, reps) => onLogSet(weight, reps, entry.value),
                onToggle: () => onToggleSet(entry.value),
                onCycleType: (type) => onCycleSetType(type, entry.value),
                onRemove: () => onRemoveSet(entry.value),
              ),
            ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: TextButton.icon(
            onPressed: isMutating ? null : onAddSet,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add set'),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // SET column - centered over the 34px circle
        const SizedBox(
          width: 34,
          child: Text(
            'SET',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB0A898),
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // WEIGHT column - centered in its Expanded space
        const Expanded(child: _ColLabel('WEIGHT')),
        const SizedBox(width: 8),
        // REPS column - centered in its Expanded space
        const Expanded(child: _ColLabel('REPS')),
        const SizedBox(width: 8),
        // Checkbox column
        const SizedBox(width: 36),
      ],
    );
  }
}

class _ColLabel extends StatelessWidget {
  const _ColLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFFB0A898),
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SetRow extends StatefulWidget {
  const _SetRow({
    required this.index,
    required this.set,
    required this.isMutating,
    required this.onLog,
    required this.onToggle,
    required this.onCycleType,
    required this.onRemove,
  });

  final int index;
  final WorkoutSet set;
  final bool isMutating;
  final void Function(double?, int?) onLog;
  final VoidCallback onToggle;
  final void Function(String) onCycleType;
  final VoidCallback onRemove;

  @override
  State<_SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<_SetRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.set.weightKg?.toString() ?? '',
    );
    _repsController = TextEditingController(
      text: widget.set.reps?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(_SetRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.set.id != widget.set.id) {
      _weightController.text = widget.set.weightKg?.toString() ?? '';
      _repsController.text = widget.set.reps?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _submit() {
    final weight = double.tryParse(_weightController.text.trim());
    final reps = int.tryParse(_repsController.text.trim());
    widget.onLog(weight, reps);
  }

  void _showTypeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Set type',
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ..._setTypeCycle.map((t) {
                final selected = widget.set.type == t;
                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? _setTypeColor(t).withAlpha(30)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(18),
                      border: selected
                          ? Border.all(color: _setTypeColor(t), width: 2)
                          : null,
                    ),
                    child: Text(
                      _setTypeLabel(t),
                      style: TextStyle(
                        fontSize: _setTypeLabel(t).length > 1 ? 9 : 13,
                        fontWeight: FontWeight.w700,
                        color: selected ? _setTypeColor(t) : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  title: Text(_typeDisplayName(t)),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: _setTypeColor(t))
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    if (!selected) {
                      widget.onCycleType(t);
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tone = widget.set.isComplete ? const Color(0xFF1F7A4D) : const Color(0xFFB45309);
    final typeLabel = _setTypeLabel(widget.set.type);
    final typeColor = _setTypeColor(widget.set.type);

    final row = Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: widget.isMutating ? null : () => _showTypeSheet(context),
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: typeLabel.isEmpty ? tone.withAlpha(30) : typeColor.withAlpha(30),
                borderRadius: BorderRadius.circular(17),
                border: typeLabel.isNotEmpty
                    ? Border.all(color: typeColor, width: 1.5)
                    : null,
              ),
              child: Text(
                typeLabel.isEmpty ? '${widget.index}' : typeLabel,
                style: TextStyle(
                  fontSize: typeLabel.isEmpty ? 14 : 11,
                  fontWeight: FontWeight.w700,
                  color: typeLabel.isEmpty ? tone : typeColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InlineField(
              hint: 'kg',
              controller: _weightController,
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InlineField(
              hint: 'reps',
              controller: _repsController,
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            height: 36,
            child: Checkbox(
              value: widget.set.isComplete,
              onChanged: widget.isMutating ? null : (_) => widget.onToggle(),
              activeColor: const Color(0xFF1F7A4D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );

    return Dismissible(
      key: ValueKey(widget.set.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) => widget.onRemove(),
      child: row,
    );
  }
}
