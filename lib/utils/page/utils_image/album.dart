import 'package:rayo/utils/import_index.dart';

class Album extends ChangeNotifier {
  Album(this._assets, this._currentAlbum, this._selectedMedias);

  Media? _selectedMedia;
  AssetPathEntity _currentAlbum;

  bool _inited = false;
  final List<Media> _selectedMedias;
  List<Media> _assets;

  List<Media> get selectedMedias => _selectedMedias;

  bool get inited => _inited;
  set inited(value) => _inited = value;

  AssetPathEntity get currentAlbum => _currentAlbum;
  setCurrentAlbum(currentAlbum, {withNotify = true}) {
    if (withNotify) notifyListeners();
    _currentAlbum = currentAlbum;
  }

  deleteSelectedMedia(Media media) {
    _selectedMedias.remove(media);

    if (_selectedMedias.isNotEmpty) {
      _selectedMedia = _selectedMedias.last;
    } else {
      _selectedMedia = null;
    }
    notifyListeners();
  }

  setCurrentMedia(Media media) {
    _selectedMedia = media;
    notifyListeners();
  }

  Media? get selectedMedia => _selectedMedia;

  singleSelectValueMedia({bool button = false}) {
    _selectedMedias.clear();
    if (button) {
      if (_selectedMedia != null) {
        _selectedMedias.add(_selectedMedia!);
      }
    }
    notifyListeners();
  }

  setCurrentMedias(Media media, int index) {
    _selectedMedias[index] = media;
    notifyListeners();
  }

  addSelectedMedia(Media media) {
    _selectedMedias.add(media);
    _selectedMedia = media;
    notifyListeners();
  }

  List<Media> get assets => _assets;

  set assets(assets) => _assets = assets;

  load(List<Media> assets) {
    _assets.addAll(assets);
    notifyListeners();
  }
}
