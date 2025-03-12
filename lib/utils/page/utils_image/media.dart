// ignore_for_file: hash_and_equals
import 'package:rayo/utils/import_index.dart';

// ignore: must_be_immutable
class Media extends AssetEntity {
  Media(id, typeInt, width, height, this.thumbdata, {this.crop})
      : super(
          id: id,
          typeInt: typeInt,
          width: width,
          height: height,
        );

  Future<Uint8List?> thumbdata;
  Crop? crop;
  Completer? completer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Media && other.id == id;
  }
}
