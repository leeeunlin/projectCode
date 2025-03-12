import 'dart:ui' as ui;

import 'package:rayo/utils/import_index.dart';

class SelectImagePage extends StatefulWidget {
  final bool multiSelect;
  final bool profile;
  const SelectImagePage(
      {required this.multiSelect, required this.profile, super.key});

  @override
  State<SelectImagePage> createState() => _SelectImagePage();
}

class _SelectImagePage extends State<SelectImagePage> {
  late List<AssetPathEntity> albums;
  late BuildContext providerCtx;
  late final Future<InitData> _data = fetchData();
  late AssetPathEntity selectAssetPathEntity = albums[0];
  bool canLoad = true;
  late ScrollController gridCtrl = ScrollController(initialScrollOffset: 0);
  bool thumbnailLoading = false;
  bool cnvLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) => snapshot.hasData && albums.isNotEmpty
            ? ChangeNotifierProvider(
                create: (context) => Album(
                    (snapshot.data as InitData).recentPhotos, albums[0], []),
                builder: (context, child) {
                  providerCtx = context;

                  return SafeArea(
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 52,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: 26,
                                      height: 26,
                                      padding: const EdgeInsets.all(6),
                                      child:
                                          SvgPicture.asset(SvgIcon.ICON_close)),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var result = await Navigator.of(context,
                                            rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) {
                                      return SelectAlbumPage(
                                          albums: albums,
                                          title: const SizedBox(),
                                          textColor: const Color(0xFFFFFFFF),
                                          backgroundColor:
                                              const Color(0xFF000000));
                                    }));

                                    switch (result.runtimeType) {
                                      case const (AssetPathEntity):
                                        selectAssetPathEntity = result;
                                        var list =
                                            await (result as AssetPathEntity)
                                                .getAssetListRange(
                                                    start: 0, end: 4 * 10);

                                        list = list
                                            .map((e) => Media(
                                                  e.id,
                                                  e.typeInt,
                                                  e.width,
                                                  e.height,
                                                  e.thumbnailDataWithSize(
                                                      const ThumbnailSize(
                                                          200, 200)),
                                                ))
                                            .toList();

                                        setState(() {
                                          providerCtx
                                              .read<Album>()
                                              .setCurrentAlbum(result);
                                          providerCtx.read<Album>().assets =
                                              list;
                                          canLoad = true;
                                        });
                                        return;
                                      default:
                                        return;
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          providerCtx
                                                      .read<Album>()
                                                      .currentAlbum
                                                      .name
                                                      .length >
                                                  10
                                              ? '${providerCtx.read<Album>().currentAlbum.name.substring(0, 10)}...'
                                              : providerCtx
                                                  .read<Album>()
                                                  .currentAlbum
                                                  .name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              height: 21.48 / 18,
                                              color: white),
                                        ),
                                        const Icon(Icons.arrow_drop_down,
                                            size: 30, color: Color(0xFFFFFFFF))
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                    onTap: providerCtx
                                                    .read<Album>()
                                                    .selectedMedia !=
                                                null &&
                                            !cnvLoading
                                        ? () async {
                                            List<CnvImgMd> detailList =
                                                await convertImage(
                                                    widget.profile);
                                            if (context1.mounted) {
                                              Navigator.pop(
                                                  context1, detailList);
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      alignment: Alignment.center,
                                      child: !cnvLoading
                                          ? Text(
                                              'confirm'.tr(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  height: 17.9 / 15,
                                                  color: providerCtx
                                                              .read<Album>()
                                                              .selectedMedia !=
                                                          null
                                                      ? white
                                                      : Colors.black),
                                            )
                                          : SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                              ),
                                            ),
                                    )),
                              ],
                            )),
                        Expanded(child: medias())
                      ],
                    ),
                  );
                })
            : const SizedBox(
                child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              )));
  }

  Widget medias() {
    List<Media> assets = providerCtx.watch<Album>().assets;

    return NotificationListener(
      child: RefreshIndicator(
        onRefresh: () async {
          var list = await selectAssetPathEntity.getAssetListRange(
              start: 0, end: 4 * 10);

          list = list
              .map((e) => Media(
                    e.id,
                    e.typeInt,
                    e.width,
                    e.height,
                    e.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                  ))
              .toList();

          setState(() {
            providerCtx.read<Album>().setCurrentAlbum(selectAssetPathEntity);
            providerCtx.read<Album>().assets = list;
            canLoad = true;
          });
        },
        child: Container(
          color: const Color(0xFF000000),
          height: MediaQuery.of(context).size.height, // 사진 하단 검은색 채우기
          child: RawScrollbar(
            thickness: 8,
            thumbVisibility: true,
            radius: const Radius.circular(20),
            thumbColor: const Color(0xEEFFFFFF),
            // trackVisibility: true,
            controller: gridCtrl,
            minThumbLength: MediaQuery.of(context).size.height * 0.05,
            child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                controller: gridCtrl,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: assets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: assets[index].thumbdata,
                      builder: (context, snapshot) => snapshot.hasData
                          ? InkWell(
                              onTap: !thumbnailLoading
                                  ? () => tapMedia(assets[index])
                                  : () {},
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Image.memory(
                                      snapshot.data as Uint8List,
                                      key: Key(assets[index].id),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (providerCtx
                                              .read<Album>()
                                              .selectedMedias
                                              .length ==
                                          10 &&
                                      !providerCtx
                                          .read<Album>()
                                          .selectedMedias
                                          .contains(assets[index]))
                                    Container(
                                        width: 100,
                                        height: 100,
                                        color: const Color(0x99000000)),
                                  if (providerCtx
                                          .read<Album>()
                                          .selectedMedias
                                          .length !=
                                      10)
                                    tag(assets[index]),
                                  if (providerCtx
                                              .read<Album>()
                                              .selectedMedias
                                              .length ==
                                          10 &&
                                      providerCtx
                                          .read<Album>()
                                          .selectedMedias
                                          .contains(assets[index]))
                                    tag(assets[index]),
                                ],
                              ),
                            )
                          : const SizedBox());
                }),
          ),
        ),
      ),
      onNotification: (t) {
        if (t is ScrollUpdateNotification) {
          if (t.metrics.extentAfter < 300 && canLoad) loadMedias();
        }
        return true;
      },
    );
  }

  loadMedias() async {
    canLoad = false;
    List<Media> assets = providerCtx.read<Album>().assets;

    List<AssetEntity> list = await providerCtx
        .read<Album>()
        .currentAlbum
        .getAssetListRange(start: assets.length, end: assets.length + 4 * 10);

    List<Media> mediaList = [];

    for (int i = 0; i < list.length; i++) {
      try {
        Future<Uint8List?> uint8data =
            list[i].thumbnailDataWithSize(const ThumbnailSize(200, 200));

        mediaList.add(Media(
          list[i].id,
          list[i].typeInt,
          list[i].width,
          list[i].height,
          uint8data,
        ));
      } catch (e) {
        // 이미지 문제로 썸네일 변환이 어려운 경우
      }
    }
    if (mounted) providerCtx.read<Album>().load(mediaList);
    canLoad = true;
  }

  tapMedia(Media media) async {
    // 초기 사진 뷰어 불러오기
    if (!providerCtx.read<Album>().inited) {
      providerCtx.read<Album>().inited = true;
    }

    if (providerCtx.read<Album>().selectedMedias.length == 1 &&
        providerCtx.read<Album>().selectedMedia == media) {
      return;
    }
    // 멀티선택이 아닌 경우 이미지 초기화하면서 다음 이미지 선택함
    if (!widget.multiSelect) {
      providerCtx.read<Album>().singleSelectValueMedia();
    }
    // 멀티선택의 경우 미디어가 포함안되어있다면 추가
    // 선택한 미디어가 포함되어 있지만 미디어가 선택된것과 현재상태가 다르면 미리보기
    // 선택한 미디어가 포함되어 있고 미디어가 선택된것과 현재상태가 같으면 삭제
    if (providerCtx.read<Album>().selectedMedias.contains(media)) {
      Media selectedMedia = providerCtx.read<Album>().selectedMedia!;
      if (selectedMedia == media) {
        providerCtx.read<Album>().deleteSelectedMedia(media);

        if (providerCtx.read<Album>().selectedMedias.isEmpty) {
          providerCtx.read<Album>().inited = false;
        }
      } else {
        providerCtx.read<Album>().setCurrentMedia(media);
      }
    } else {
      if (providerCtx.read<Album>().selectedMedias.length >= 10) {
        return;
      }

      if (!mounted) return;
      providerCtx.read<Album>().addSelectedMedia(media);
    }
  }

  Widget tag(Media media) {
    Color backgroundColor = Colors.transparent;
    bool selectedMedia = false;
    if (!widget.multiSelect &&
        providerCtx.watch<Album>().selectedMedia != null) {
      backgroundColor = const Color(0x61000000);
    }
    if (widget.multiSelect &&
        providerCtx.watch<Album>().selectedMedias.length == 10) {
      backgroundColor = const Color(0x61000000);
    }
    int idx =
        providerCtx.watch<Album>().selectedMedias.indexWhere((e) => e == media);
    if (idx != -1) {
      selectedMedia = true;
    }
    if (idx != -1 && media == providerCtx.watch<Album>().selectedMedia) {
      backgroundColor = Colors.transparent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: selectedMedia ? Colors.transparent : backgroundColor,
      alignment: Alignment.topLeft,
      height: 100,
      width: 100,
      child: Wrap(
        children: [
          Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFFFFF))),
              child: selectedMedia
                  ? SvgPicture.asset(
                      SvgIcon.ICON_checkCircle,
                      theme: SvgTheme(currentColor: yellow),
                    )
                  : null)
        ],
      ),
    );
  }

  Future<void> getImageDimensions(Uint8List memoryImage) async {
    ui.Image image = await _loadImage(memoryImage);
    int width = image.width;
    int height = image.height;
    p('Width: $width, Height: $height');
  }

  Future<ui.Image> _loadImage(Uint8List imgBytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<List<CnvImgMd>> convertImage(bool profile) async {
    List<CnvImgMd> items = [];
    List<Media> medias = providerCtx.read<Album>().selectedMedias;
    p('width: ${medias[0].width} | height: ${medias[0].height}');
    setState(() {
      cnvLoading = true;
    });
    for (Media media in medias) {
      String filePath = '';
      Uint8List? memoryImage =
          await media.thumbnailDataWithSize(const ThumbnailSize(1200, 1200));
      await getImageDimensions(memoryImage!);
      p('size: ${memoryImage.length / 1000}KB');

      if (profile) {
        File? file = await media.file;
        filePath = file!.path;
      }
      items.add(
          CnvImgMd(memoryImage: memoryImage, path: filePath, media: media));
    }
    return items;
  }

  Future<InitData> fetchData() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        filterOption: FilterOptionGroup(containsPathModified: true));
    List<AssetPathEntity> onlyImageAlbums = [];

    for (int i = 0; i < albums.length; i++) {
      var list = await albums[i].getAssetListRange(start: 0, end: 4 * 10);

      if (list.isNotEmpty) onlyImageAlbums.add(albums[i]);
    }

    this.albums = onlyImageAlbums;

    var list = await albums[0].getAssetListRange(start: 0, end: 4 * 10);
    return InitData(
      recentPhotos: list
          .map(
            (e) => Media(
              e.id,
              e.typeInt,
              e.width,
              e.height,
              e.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            ),
          )
          .toList(),
    );
  }
}

class InitData {
  final List<Media> recentPhotos;
  InitData({required this.recentPhotos});
}

class CnvImgMd {
  String? path;
  Uint8List? memoryImage;
  Media? media;

  CnvImgMd({
    this.path,
    this.memoryImage,
    this.media,
  });
}
