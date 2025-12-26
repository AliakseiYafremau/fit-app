import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Displays a very lightweight interactive diagram that mimics a stacked SVG
/// layer. Tapping on "muscle" areas toggles their highlight state.
class InteractiveSvgDiagram extends StatefulWidget {
  const InteractiveSvgDiagram({
    super.key,
    this.initialSelection = const <String>{},
    this.onSelectionChanged,
  });

  final Set<String> initialSelection;
  final ValueChanged<Set<String>>? onSelectionChanged;

  @override
  State<InteractiveSvgDiagram> createState() => _InteractiveSvgDiagramState();
}

class _InteractiveSvgDiagramState extends State<InteractiveSvgDiagram> {
  late final Set<String> _selected = Set<String>.from(widget.initialSelection);

  @override
  void initState() {
    super.initState();
    if (widget.onSelectionChanged != null && _selected.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _notifySelection());
    }
  }

  void _toggleRegion(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
    _notifySelection();
  }

  void _notifySelection() {
    if (widget.onSelectionChanged == null) return;
    final labels = _selected
        .map(
          (id) => _muscleRegions.firstWhere((region) => region.id == id).label,
        )
        .toSet();
    widget.onSelectionChanged!(labels);
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade500;
    final highlightColor = Colors.orange.shade400;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.grey.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final region in _muscleRegions)
            for (final shape in region.shapes)
              _RegionShapeTile(
                regionId: region.id,
                label: region.label,
                shape: shape,
                selected: _selected.contains(region.id),
                baseColor: baseColor,
                highlightColor: highlightColor,
                onTap: () => _toggleRegion(region.id),
              ),
        ],
      ),
    );
  }
}

class _RegionShapeTile extends StatelessWidget {
  const _RegionShapeTile({
    required this.regionId,
    required this.label,
    required this.shape,
    required this.selected,
    required this.baseColor,
    required this.highlightColor,
    required this.onTap,
  });

  final String regionId;
  final String label;
  final _RegionShape shape;
  final bool selected;
  final Color baseColor;
  final Color highlightColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? highlightColor : baseColor;
    final angle = shape.rotationDegrees * math.pi / 180;
    final body = _ShapeBody(color: color, shape: shape);
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      child: Align(
        alignment: shape.alignment,
        child: FractionallySizedBox(
          widthFactor: shape.widthFactor,
          heightFactor: shape.heightFactor,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: Transform.rotate(
                angle: angle,
                child: Padding(padding: const EdgeInsets.all(6), child: body),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShapeBody extends StatelessWidget {
  const _ShapeBody({required this.color, required this.shape});

  final Color color;
  final _RegionShape shape;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color,
      borderRadius: shape.type == _RegionShapeType.rectangle
          ? shape.borderRadius
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: decoration,
    );
    if (shape.type == _RegionShapeType.triangle) {
      return ClipPath(clipper: _TriangleClipper(), child: child);
    }
    return child;
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

enum _RegionShapeType { rectangle, triangle }

class _RegionShape {
  const _RegionShape._({
    required this.type,
    required this.alignment,
    required this.widthFactor,
    required this.heightFactor,
    required this.rotationDegrees,
    required this.borderRadius,
  });

  const _RegionShape.rectangle({
    required Alignment alignment,
    required double widthFactor,
    required double heightFactor,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(24)),
    double rotationDegrees = 0,
  }) : this._(
         type: _RegionShapeType.rectangle,
         alignment: alignment,
         widthFactor: widthFactor,
         heightFactor: heightFactor,
         rotationDegrees: rotationDegrees,
         borderRadius: borderRadius,
       );

  const _RegionShape.triangle({
    required Alignment alignment,
    required double widthFactor,
    required double heightFactor,
    double rotationDegrees = 0,
  }) : this._(
         type: _RegionShapeType.triangle,
         alignment: alignment,
         widthFactor: widthFactor,
         heightFactor: heightFactor,
         rotationDegrees: rotationDegrees,
         borderRadius: BorderRadius.zero,
       );

  final _RegionShapeType type;
  final Alignment alignment;
  final double widthFactor;
  final double heightFactor;
  final double rotationDegrees;
  final BorderRadius borderRadius;
}

class _MuscleRegion {
  const _MuscleRegion({
    required this.id,
    required this.label,
    required this.shapes,
  });

  final String id;
  final String label;
  final List<_RegionShape> shapes;
}

const List<_MuscleRegion> _muscleRegions = <_MuscleRegion>[
  _MuscleRegion(
    id: 'shoulders',
    label: 'Shoulders',
    shapes: [
      _RegionShape.rectangle(
        alignment: Alignment(0, -0.9),
        widthFactor: 0.55,
        heightFactor: 0.18,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
      ),
    ],
  ),
  _MuscleRegion(
    id: 'chest',
    label: 'Chest',
    shapes: [
      _RegionShape.rectangle(
        alignment: Alignment(0, -0.5),
        widthFactor: 0.6,
        heightFactor: 0.22,
      ),
    ],
  ),
  _MuscleRegion(
    id: 'arms',
    label: 'Arms',
    shapes: [
      _RegionShape.rectangle(
        alignment: Alignment(-0.45, -0.2),
        widthFactor: 0.45,
        heightFactor: 0.16,
        rotationDegrees: -12,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      _RegionShape.rectangle(
        alignment: Alignment(0.45, -0.2),
        widthFactor: 0.45,
        heightFactor: 0.16,
        rotationDegrees: 12,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
    ],
  ),
  _MuscleRegion(
    id: 'core',
    label: 'Core',
    shapes: [
      _RegionShape.triangle(
        alignment: Alignment(-0.2, 0.05),
        widthFactor: 0.35,
        heightFactor: 0.18,
        rotationDegrees: -10,
      ),
      _RegionShape.triangle(
        alignment: Alignment(0.2, 0.05),
        widthFactor: 0.35,
        heightFactor: 0.18,
        rotationDegrees: 10,
      ),
    ],
  ),
  _MuscleRegion(
    id: 'hips',
    label: 'Hips',
    shapes: [
      _RegionShape.rectangle(
        alignment: Alignment(0, 0.4),
        widthFactor: 0.5,
        heightFactor: 0.18,
      ),
    ],
  ),
  _MuscleRegion(
    id: 'legs',
    label: 'Legs',
    shapes: [
      _RegionShape.triangle(
        alignment: Alignment(0, 0.75),
        widthFactor: 0.55,
        heightFactor: 0.32,
      ),
      _RegionShape.rectangle(
        alignment: Alignment(0, 1),
        widthFactor: 0.25,
        heightFactor: 0.25,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
    ],
  ),
];
