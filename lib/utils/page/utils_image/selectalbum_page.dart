import 'package:rayo/utils/import_index.dart';

class SelectAlbumPage extends StatelessWidget {
  SelectAlbumPage(
      {required this.albums,
      required this.title,
      required this.backgroundColor,
      required this.textColor,
      super.key});

  final List<AssetPathEntity> albums;
  late final Future<List<AlbumData>> _data = _fetchData;

  final Widget? title;
  final Color backgroundColor, textColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            shape: const Border(),
            leading: IconButton(
              icon: const Icon(Icons.close),
              color: textColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            title: title,
            pinned: true,
          ),
          FutureBuilder(
            future: _data,
            builder: (context, snapshot) => snapshot.hasData
                ? SliverFillRemaining(
                    child: ListView.separated(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.pop(context, snapshot.data![index].album);
                          },
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.memory(
                                  snapshot.data![index].thumbnail,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 15),
                                IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].album.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        snapshot.data![index].count.toString(),
                                        style: TextStyle(
                                            color: textColor.withAlpha(179)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 30);
                    },
                  ))
                : const SliverFillRemaining(),
          ),
        ]),
      ),
    );
  }

  Future<List<AlbumData>> get _fetchData async {
    var futures = albums.map((e) async {
      List<AssetEntity> assets = await e.getAssetListRange(start: 0, end: 1);
      Uint8List thumbnail = (await assets[0]
          .thumbnailDataWithSize(const ThumbnailSize(200, 200)))!;
      return AlbumData(e, await e.assetCountAsync, thumbnail);
    }).toList();

    List<AlbumData> results = await Future.wait(futures);

    return results;
  }
}

class AlbumData {
  final AssetPathEntity album;
  final int count;
  final Uint8List thumbnail;

  AlbumData(this.album, this.count, this.thumbnail);
}
