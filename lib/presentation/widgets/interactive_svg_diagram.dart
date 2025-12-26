import 'dart:math' as math;

import 'package:flutter/foundation.dart';
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
    final region = _muscleRegions.firstWhere(
      (element) => element.id == id,
      orElse: () {
        throw StateError('Unknown region $id');
      },
    );
    if (!region.selectable) return;
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 320,
              height: 520,
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
                        selectable: region.selectable,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        onTap: () => _toggleRegion(region.id),
                      ),
                ],
              ),
            ),
          ),
        ),
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
    required this.selectable,
    required this.baseColor,
    required this.highlightColor,
    required this.onTap,
  });

  final String regionId;
  final String label;
  final _RegionShape shape;
  final bool selected;
  final bool selectable;
  final Color baseColor;
  final Color highlightColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selectable
        ? (selected ? highlightColor : baseColor)
        : baseColor.withValues(alpha: 0.4);
    final angle = shape.rotationDegrees * math.pi / 180;
    final body = _ShapeBody(color: color, shape: shape);
    return Semantics(
      label: label,
      button: selectable,
      selected: selectable && selected,
      child: Align(
        alignment: shape.alignment,
        child: FractionallySizedBox(
          widthFactor: shape.widthFactor,
          heightFactor: shape.heightFactor,
          child: MouseRegion(
            cursor: selectable
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: GestureDetector(
              onTap: selectable ? onTap : null,
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
    if (shape.type == _RegionShapeType.polygon) {
      return ClipPath(
        clipper: _PolygonClipper(shape.polygonPoints),
        child: child,
      );
    }
    return child;
  }
}

class _PolygonClipper extends CustomClipper<Path> {
  _PolygonClipper(this.points);

  final List<Offset> points;

  @override
  Path getClip(Size size) {
    if (points.isEmpty) return Path();
    final scaled = points
        .map((point) => Offset(point.dx * size.width, point.dy * size.height))
        .toList(growable: false);
    final path = Path()..moveTo(scaled.first.dx, scaled.first.dy);
    for (var i = 1; i < scaled.length; i++) {
      path.lineTo(scaled[i].dx, scaled[i].dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _PolygonClipper oldClipper) =>
      !listEquals(points, oldClipper.points);
}

enum _RegionShapeType { rectangle, polygon }

class _RegionShape {
  const _RegionShape._({
    required this.type,
    required this.alignment,
    required this.widthFactor,
    required this.heightFactor,
    required this.rotationDegrees,
    required this.borderRadius,
    required this.polygonPoints,
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
         polygonPoints: const <Offset>[],
       );

  const _RegionShape.polygon({
    required Alignment alignment,
    required double widthFactor,
    required double heightFactor,
    required List<Offset> points,
    double rotationDegrees = 0,
  }) : this._(
         type: _RegionShapeType.polygon,
         alignment: alignment,
         widthFactor: widthFactor,
         heightFactor: heightFactor,
         rotationDegrees: rotationDegrees,
         borderRadius: BorderRadius.zero,
         polygonPoints: points,
       );

  final _RegionShapeType type;
  final Alignment alignment;
  final double widthFactor;
  final double heightFactor;
  final double rotationDegrees;
  final BorderRadius borderRadius;
  final List<Offset> polygonPoints;
}

class _MuscleRegion {
  const _MuscleRegion({
    required this.id,
    required this.label,
    required this.shapes,
    this.selectable = true,
  });

  final String id;
  final String label;
  final List<_RegionShape> shapes;
  final bool selectable;
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
      _RegionShape.polygon(
        alignment: Alignment(-0.2, 0.05),
        widthFactor: 0.35,
        heightFactor: 0.18,
        rotationDegrees: -10,
        points: _trianglePoints,
      ),
      _RegionShape.polygon(
        alignment: Alignment(0.2, 0.05),
        widthFactor: 0.35,
        heightFactor: 0.18,
        rotationDegrees: 10,
        points: _trianglePoints,
      ),
    ],
  ),
  _MuscleRegion(
    id: 'hips',
    label: 'Hips',
    selectable: false,
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
      _RegionShape.polygon(
        alignment: Alignment(0, 0.75),
        widthFactor: 0.55,
        heightFactor: 0.32,
        points: _trianglePoints,
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

const List<Offset> _trianglePoints = <Offset>[
  Offset(0.5, 0),
  Offset(1, 1),
  Offset(0, 1),
];
