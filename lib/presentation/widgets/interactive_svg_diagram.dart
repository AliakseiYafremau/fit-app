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
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
    return ClipPath(
      clipper: _PolygonClipper(shape.normalizedPoints),
      child: child,
    );
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

class _RegionShape {
  const _RegionShape({
    this.alignment = Alignment.center,
    this.rotationDegrees = 0,
    required this.points,
  });

  final Alignment alignment;
  final double rotationDegrees;
  final List<Offset> points;

  static const double _minFactor = 0.0001;

  Rect get _bounds {
    if (points.isEmpty) return Rect.zero;
    var minDx = points.first.dx;
    var maxDx = points.first.dx;
    var minDy = points.first.dy;
    var maxDy = points.first.dy;
    for (final point in points.skip(1)) {
      if (point.dx < minDx) minDx = point.dx;
      if (point.dx > maxDx) maxDx = point.dx;
      if (point.dy < minDy) minDy = point.dy;
      if (point.dy > maxDy) maxDy = point.dy;
    }
    return Rect.fromLTRB(minDx, minDy, maxDx, maxDy);
  }

  double get widthFactor {
    final width = _bounds.width;
    return width > 0 ? width : _minFactor;
  }

  double get heightFactor {
    final height = _bounds.height;
    return height > 0 ? height : _minFactor;
  }

  List<Offset> get normalizedPoints {
    if (points.isEmpty) return const <Offset>[];
    final bounds = _bounds;
    final width = bounds.width == 0 ? 1 : bounds.width;
    final height = bounds.height == 0 ? 1 : bounds.height;
    return points
        .map(
          (point) => Offset(
            (point.dx - bounds.left) / width,
            (point.dy - bounds.top) / height,
          ),
        )
        .toList(growable: false);
  }
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
  _MuscleRegion(id: "abd", label: "Abd", shapes: <_RegionShape>[
    _RegionShape(
      alignment: Alignment(0, -0.04),
      rotationDegrees: 0,
      points: <Offset>[
        Offset(-0.18, 0),
        Offset(0.18, 0),
        Offset(0.13, 0.13),
        Offset(-0.13, 0.13),
      ],
    ),
  ]),
  _MuscleRegion(
    id: 'upper_legs',
    label: 'Upper Legs',
    shapes: <_RegionShape>[
      _RegionShape(
        alignment: Alignment(-0.21, 0.24),
        rotationDegrees: 0,
        points: <Offset>[
          Offset(0, 0),
          Offset(0.12, 0),
          Offset(0.05, 0.14),
          Offset(-0.04, 0.14),
        ],
      ),
      _RegionShape(
        alignment: Alignment(0.21, 0.24),
        rotationDegrees: 0,
        points: <Offset>[
          Offset(0, 0),
          Offset(-0.12, 0),
          Offset(-0.05, 0.14),
          Offset(0.04, 0.14),
        ],
      ),
    ],
  ),
  _MuscleRegion(
    id: 'low_legs',
    label: 'Low Legs',
    shapes: <_RegionShape>[
      _RegionShape(
        alignment: Alignment(-0.24, 0.58),
        rotationDegrees: 0,
        points: <Offset>[
          Offset(0, 0),
          Offset(0.1, 0),
          Offset(0.12, 0.17),
          Offset(0.04, 0.17),
        ],
      ),
      _RegionShape(
        alignment: Alignment(0.24, 0.58),
        rotationDegrees: 0,
        points: <Offset>[
          Offset(0, 0),
          Offset(-0.1, 0),
          Offset(-0.12, 0.17),
          Offset(-0.04, 0.17),
        ],
      ),
    ],
  ),
  _MuscleRegion(
    id: 'feet',
    label: 'Feet',
    selectable: false,
    shapes: <_RegionShape>[
      _RegionShape(
        alignment: Alignment(-0.35, 0.7),
        rotationDegrees: 0,
        points: <Offset>[
          Offset(0, 0),
          Offset(0.1, 0),
          Offset(0.12, 0.05),
          Offset(-0.1, 0.05),
        ],
      ),
      _RegionShape(
        alignment: Alignment(0.35, 0.7),
        rotationDegrees: 0,
        points: <Offset>[
          Offset(0, 0),
          Offset(-0.1, 0),
          Offset(-0.12, 0.05),
          Offset(0.1, 0.05),
        ],
      ),
    ],
  ),
];
