import 'dart:math';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' as v;

import 'package:flutter/material.dart';

class ThreeView extends StatefulWidget {
  @override
  _ThreeViewState createState() => _ThreeViewState();
}

class _ThreeViewState extends State<ThreeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return _ThreeWidget(
          progress: _animationController.value,
        );
      },
    );
  }
}

class _ThreeWidget extends LeafRenderObjectWidget {
  final double progress;

  _ThreeWidget({
    required this.progress,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderThree(
      progress: progress,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderThree renderObject) {
    renderObject..progress = progress;
  }
}

class _RenderThree extends RenderBox {
  double _progress;

  set progress(double value) {
    if (_progress != value) {
      _progress = value;
      markNeedsPaint();
    }
  }

  Paint _linePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  _RenderThree({
    required double progress,
  }) : _progress = progress;

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.clipRect(Offset.zero & size);

    _linePaint.color = Colors.blueAccent;

    List<v.Vector3> points = [
      v.Vector3(-0.5, 0.5, 0.5),
      v.Vector3(0.5, -0.5, 0.5),
      v.Vector3(-0.5, -0.5, 0.5),
      v.Vector3(-0.5, 0.5, 0.5),
      v.Vector3(0.5, -0.5, 0.5),
      v.Vector3(0.5, 0.5, 0.5),
      v.Vector3(-0.5, 0.5, -0.5),
      v.Vector3(0.5, -0.5, -0.5),
      v.Vector3(-0.5, -0.5, -0.5),
      v.Vector3(-0.5, 0.5, -0.5),
      v.Vector3(0.5, -0.5, -0.5),
      v.Vector3(0.5, 0.5, -0.5),
      //
      v.Vector3(-0.5, 0.5, 0.5),
      v.Vector3(-0.5, -0.5, 0.5),
      v.Vector3(-0.5, -0.5, -0.5),
      v.Vector3(-0.5, 0.5, 0.5),
      v.Vector3(-0.5, -0.5, -0.5),
      v.Vector3(-0.5, 0.5, -0.5),
      v.Vector3(0.5, 0.5, 0.5),
      v.Vector3(0.5, -0.5, 0.5),
      v.Vector3(0.5, -0.5, -0.5),
      v.Vector3(0.5, 0.5, 0.5),
      v.Vector3(0.5, -0.5, -0.5),
      v.Vector3(0.5, 0.5, -0.5),
      //
      v.Vector3(-0.5, 0.5, 0.5),
      v.Vector3(0.5, 0.5, -0.5),
      v.Vector3(0.5, 0.5, 0.5),
      v.Vector3(-0.5, 0.5, 0.5),
      v.Vector3(0.5, 0.5, -0.5),
      v.Vector3(-0.5, 0.5, -0.5),
      v.Vector3(-0.5, -0.5, 0.5),
      v.Vector3(0.5, -0.5, -0.5),
      v.Vector3(0.5, -0.5, 0.5),
      v.Vector3(-0.5, -0.5, 0.5),
      v.Vector3(0.5, -0.5, -0.5),
      v.Vector3(-0.5, -0.5, -0.5),
    ];

    double n = 0.1;
    double f = 100.0;
    double fov = (45.0 / 180.0) * pi;

    Matrix4 projection = Matrix4.columns(
      v.Vector4((cos(fov / 2.0) / sin(fov / 2.0)) / (size.width / size.height),
          0.0, 0.0, 0.0),
      v.Vector4(0.0, cos(fov / 2.0) / sin(fov / 2.0), 0.0, 0.0),
      v.Vector4(0.0, 0.0, -(f + n) / (f - n), (-2.0 * f * n) / (f - n)),
      v.Vector4(0.0, 0.0, -1.0, 0.0),
    ).transposed();

    Matrix4 viewPort = Matrix4.columns(
      v.Vector4(size.width / 2.0, 0.0, 0.0, size.width / 2.0),
      v.Vector4(0.0, size.height / 2.0, 0.0, size.height / 2.0),
      v.Vector4(0.0, 0.0, (f - n) / 2.0, (n + f) / 2.0),
      v.Vector4(0.0, 0.0, 0.0, 1.0),
    ).transposed();

    Matrix4 model = Matrix4.identity();
    model.rotate(v.Vector3(1.0, 1.0, 1.0), pi * 2 * _progress);
    model.scale(0.4, 0.4, 0.4);

    points = points
        .map((e) =>
            viewPort.transform3(projection.transform3(model.transform3(e))))
        .toList();

    /*for(int i=0;i<points.length-3;i+=3){
      for(int j=0;j<points.length-i-3;j+=3){
        double az=max(points[i].z,max(points[i+1].z,points[i+2].z));
        double bz=max(points[j].z,max(points[j+1].z,points[j+2].z));
        if(az>bz){
          v.Vector3 temp=points[i];
          points[i]=points[j];
          points[j]=temp;

          temp=points[i+1];
          points[i+1]=points[j+1];
          points[j+1]=temp;

          temp=points[i+2];
          points[i+2]=points[j+2];
          points[j+2]=temp;
        }
      }
    }*/

    canvas.drawVertices(
      ui.Vertices(
        ui.VertexMode.triangles,
        points.map((e) => Offset(e.x, e.y)).toList(),
        colors: [
          for (int i = 0; i < points.length ~/ 6; i++) ...[
            Colors.orangeAccent.withOpacity(0.3),
            Colors.yellowAccent.withOpacity(0.3),
            Colors.greenAccent.withOpacity(0.3),
            Colors.lightGreenAccent.withOpacity(0.3),
            Colors.blueAccent.withOpacity(0.3),
            Colors.orangeAccent.withOpacity(0.3),
          ]
        ],
      ),
      BlendMode.src,
      _linePaint,
    );

    canvas.restore();
  }
}
