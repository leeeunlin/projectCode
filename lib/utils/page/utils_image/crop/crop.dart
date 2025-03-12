// ignore_for_file: unused_element
import 'package:rayo/utils/import_index.dart';

import 'dart:ui' as ui;

/// Used for cropping the [child] widget.
class Crop extends StatefulWidget {
  /// The constructor.
  const Crop({
    super.key,
    required this.child,
    required this.controller,
    this.padding = const EdgeInsets.all(8),
    this.dimColor = const Color.fromRGBO(0, 0, 0, 0.8),
    this.backgroundColor = Colors.black,
    this.background,
    this.foreground,
    this.helper,
    this.overlay,
    this.interactive = true,
    this.shape = BoxShape.rectangle,
    this.onChanged,
    this.animationDuration = const Duration(milliseconds: 200),
    this.radius,
    this.scaleLimit,
  });

  final Widget child;
  final CropController controller;
  final Color backgroundColor;
  final Color dimColor;
  final EdgeInsets padding;
  final Widget? background;
  final Widget? foreground;
  final Widget? helper;
  final Widget? overlay;
  final bool interactive;
  final BoxShape shape;
  final ValueChanged<MatrixDecomposition>? onChanged;
  final Duration animationDuration;
  final Radius? radius;

  /// Maximum zoom scale
  final double? scaleLimit;

  @override
  State<StatefulWidget> createState() {
    return _CropState();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(ColorProperty('dimColor', dimColor));
    properties.add(DiagnosticsProperty('child', child));
    properties.add(DiagnosticsProperty('controller', controller));
    properties.add(DiagnosticsProperty('background', background));
    properties.add(DiagnosticsProperty('foreground', foreground));
    properties.add(DiagnosticsProperty('helper', helper));
    properties.add(DiagnosticsProperty('overlay', overlay));
    properties.add(FlagProperty(
      'interactive',
      value: interactive,
      ifTrue: 'enabled',
      ifFalse: 'disabled',
      showName: true,
    ));
  }

  Crop copyWith({
    Key? key,
    Widget? child,
    CropController? controller,
    Color? backgroundColor,
    Color? dimColor,
    EdgeInsets? padding,
    Widget? background,
    Widget? foreground,
    Widget? helper,
    Widget? overlay,
    bool? interactive,
    BoxShape? shape,
    ValueChanged<MatrixDecomposition>? onChanged,
    Duration? animationDuration,
    Radius? radius,
    double? scaleLimit,
  }) {
    return Crop(
      key: key ?? this.key,
      controller: controller ?? this.controller,
      padding: padding ?? this.padding,
      dimColor: dimColor ?? this.dimColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      helper: helper ?? this.helper,
      overlay: overlay ?? this.overlay,
      interactive: interactive ?? this.interactive,
      shape: shape ?? this.shape,
      onChanged: onChanged ?? this.onChanged,
      animationDuration: animationDuration ?? this.animationDuration,
      radius: radius ?? this.radius,
      scaleLimit: scaleLimit ?? this.scaleLimit,
      child: child ?? this.child,
    );
  }
}

class _CropState extends State<Crop> with TickerProviderStateMixin {
  final _key = GlobalKey();
  final _parent = GlobalKey();
  final _repaintBoundaryKey = GlobalKey();
  final _childKey = GlobalKey();

  double _previousScale = 1;
  Offset _previousOffset = Offset.zero;
  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;
  bool isInit = true;

  /// Store the pointer count (finger involved to perform scaling).
  ///
  /// This is used to compare with the value in
  /// [ScaleUpdateDetails.pointerCount]. Check [_onScaleUpdate] for detail.

  late AnimationController _controller;
  late CurvedAnimation _animation;

  Future<ui.Image> _crop(double pixelRatio) {
    final rrb = _repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    return rrb.toImage(pixelRatio: pixelRatio);
  }

  @override
  void initState() {
    widget.controller._cropCallback = _crop;
    widget.controller.addListener(_reCenterImage);

    if (widget.controller.offset != Offset.zero) {
      _startOffset = widget.controller._offset;

      _endOffset = _startOffset;
    }

    //Setup animation.
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(curve: Curves.easeInOut, parent: _controller);
    _animation.addListener(() {
      if (_animation.isCompleted) {
        _reCenterImage(
          animate: false,
        );
      }
      setState(() {});
    });

    super.initState();
  }

  void _reCenterImage({bool? animate = true}) {
    _startOffset = widget.controller._offset;

    final widgetSize = _key.currentContext!.size!;
    final childBox =
        (_childKey.currentContext?.findRenderObject() as RenderBox);
    final childXform = childBox.getTransformTo(null);
    final viewScale = childXform.row0[0];
    final imageDimensions = childBox.paintBounds;
    final imageScreenSize = Size(
        imageDimensions.width * viewScale, imageDimensions.height * viewScale);

    final maxDx = max(0.0, imageScreenSize.width - widgetSize.width) / 2;
    final maxDy = max(0.0, imageScreenSize.height - widgetSize.height) / 2;

    widget.controller._offset = _endOffset = Offset(
        _startOffset.dx.clamp(-maxDx, maxDx),
        _startOffset.dy.clamp(-maxDy, maxDy));

    if (animate!) {
      if (_controller.isCompleted || _controller.isAnimating) {
        _controller.reset();
      }
      _controller.forward();
    } else {
      _startOffset = _endOffset;
    }

    setState(() {});
    _handleOnChanged();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    widget.controller._offset += details.focalPoint - _previousOffset;
    _previousOffset = details.focalPoint;
    widget.controller._scale = _previousScale * details.scale;
    if (widget.scaleLimit != null &&
        widget.controller._scale > widget.scaleLimit!) {
      widget.controller._scale = widget.scaleLimit!;
    }
    _startOffset = widget.controller._offset;
    _endOffset = widget.controller._offset;

    setState(() {});
    _handleOnChanged();
  }

  void _handleOnChanged() {
    widget.onChanged?.call(MatrixDecomposition(
        scale: widget.controller.scale,
        rotation: 0,
        translation: widget.controller._offset));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.controller._scale;
    final f = radians(widget.controller._rotation);
    final o = Offset.lerp(_startOffset, _endOffset, _animation.value)!;

    Widget buildInnerCanvas() {
      final ip = IgnorePointer(
        key: _key,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(o.dx, o.dy, 0)
            ..rotateZ(f)
            ..scale(s, s, 1),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(key: _childKey, child: widget.child),
          ),
        ),
      );

      List<Widget> widgets = [];

      if (widget.background != null) {
        widgets.add(widget.background!);
      }

      widgets.add(ip);

      if (widget.foreground != null) {
        widgets.add(widget.foreground!);
      }

      if (widgets.length == 1) {
        return ip;
      } else {
        return Stack(
          fit: StackFit.expand,
          children: widgets,
        );
      }
    }

    Widget buildRepaintBoundary() {
      final repaint = RepaintBoundary(
        key: _repaintBoundaryKey,
        child: buildInnerCanvas(),
      );

      final helper = widget.helper;

      if (helper == null) {
        return repaint;
      }

      return Stack(
        fit: StackFit.expand,
        children: [repaint, helper],
      );
    }

    final gd = GestureDetector(
      onScaleStart: (details) {
        _previousOffset = details.focalPoint;
        _previousScale = max(widget.controller._scale, 1);
      },
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: (details) {
        widget.controller._scale = max(widget.controller._scale, 1);
        _reCenterImage();
      },
    );

    List<Widget> over = [
      CropRenderObjectWidget(
        aspectRatio: widget.controller._aspectRatio,
        backgroundColor: widget.backgroundColor,
        shape: widget.shape,
        dimColor: widget.dimColor,
        child: buildRepaintBoundary(),
      ),
    ];

    if (widget.overlay != null) {
      over.add(widget.overlay!);
    }

    if (widget.interactive) {
      over.add(gd);
    }

    return ClipRect(
      key: _parent,
      child: Stack(
        fit: StackFit.expand,
        children: over,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller.removeListener(_reCenterImage);
    super.dispose();
  }
}

typedef _CropCallback = Future<ui.Image> Function(double pixelRatio);

/// The controller used to control the rotation, scale and actual cropping.
class CropController extends ChangeNotifier {
  double _aspectRatio = 1;
  double _rotation = 0;
  double _scale = 1;
  Offset _offset = Offset.zero;
  _CropCallback? _cropCallback;

  /// Gets the current aspect ratio.
  double get aspectRatio => _aspectRatio;

  /// Sets the desired aspect ratio.
  set aspectRatio(double value) {
    _aspectRatio = value;
    notifyListeners();
  }

  /// Gets the current scale.
  double get scale => max(_scale, 1);

  /// Sets the desired scale.
  set scale(double value) {
    _scale = max(value, 1);
    notifyListeners();
  }

  /// Gets the current rotation.
  double get rotation => _rotation;

  /// Sets the desired rotation.
  set rotation(double value) {
    _rotation = value;
    notifyListeners();
  }

  /// Gets the current offset.
  Offset get offset => _offset;

  /// Sets the desired offset.
  set offset(Offset value) {
    _offset = value;
    notifyListeners();
  }

  /// Gets the transformation matrix.
  Matrix4 get transform => Matrix4.identity()
    ..translate(_offset.dx, _offset.dy, 0)
    ..rotateZ(_rotation)
    ..scale(_scale, _scale, 1);

  /// Constructor
  CropController({
    double aspectRatio = 1.0,
    double scale = 1.0,
    double rotation = 0,
  }) {
    _aspectRatio = aspectRatio;
    _scale = scale;
    _rotation = rotation;
  }

  double _getMinScale() {
    final r = radians(_rotation % 360);
    final rabs = r.abs();

    final sinr = sin(rabs).abs();
    final cosr = cos(rabs).abs();

    final x = cosr * _aspectRatio + sinr;
    final y = sinr * _aspectRatio + cosr;

    final m = max(x / _aspectRatio, y);

    return m;
  }

  /// Capture an image of the current state of this widget and its children.
  ///
  /// The returned [ui.Image] has uncompressed raw RGBA bytes, will have
  /// dimensions equal to the size of the [child] widget multiplied by [pixelRatio].
  ///
  /// The [pixelRatio] describes the scale between the logical pixels and the
  /// size of the output image. It is independent of the
  /// [window.devicePixelRatio] for the device, so specifying 1.0 (the default)
  /// will give you a 1:1 mapping between logical pixels and the output pixels
  /// in the image.
  Future<ui.Image?> crop({double pixelRatio = 1}) {
    if (_cropCallback == null) {
      return Future.value(null);
    }

    return _cropCallback!.call(pixelRatio);
  }
}

Vector2 _toVector2(Offset offset) => Vector2(offset.dx, offset.dy);
Offset _toOffset(Vector2 v) => Offset(v.x, v.y);
