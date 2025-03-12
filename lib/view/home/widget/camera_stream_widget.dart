import 'package:rayo/utils/import_index.dart';
import 'dart:ui' as ui;

// ignore_for_file: constant_identifier_names
class CameraStreamWidget extends StatefulWidget {
  static const String PLUGIN_VIEW_TYPE = "ArCameraView";

  const CameraStreamWidget(
      {required this.width, required this.height, super.key});
  final double width;
  final double height;
  @override
  CameraStreamWidgetState createState() => CameraStreamWidgetState();
}

class CameraStreamWidgetState extends State<CameraStreamWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 사용 시 필요
    Map<String, dynamic> creationParams = <String, dynamic>{
      'width': widget.width,
      'height': widget.height,
    };
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: CameraStreamWidget.PLUGIN_VIEW_TYPE,
        layoutDirection: ui.TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        viewType: CameraStreamWidget.PLUGIN_VIEW_TYPE,
        layoutDirection: ui.TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}
