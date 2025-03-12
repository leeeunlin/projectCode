import 'package:rayo/utils/import_index.dart';

void p(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

Future<List<MultipartFile>> convertMultipartFiles(List<List<int>> image) async {
  List<MultipartFile> multipartFiles = [];
  for (int i = 0; i < image.length; i++) {
    multipartFiles.add(
      MultipartFile.fromBytes(
        'image',
        image[i],
        filename: 'image$i.jpg',
      ),
    );
  }
  return multipartFiles;
}
