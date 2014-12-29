part of the_path;

class AssetManager {
  final Map<String, ImageElement> _images  = new Map<String, ImageElement>();
  final Map<String, Sprite>       _sprites = new Map<String, Sprite>();

  void loadImage(String name, String imageSource) {
    _images[name] = new ImageElement(src: imageSource);
  }

  ImageElement image(String name) => _images[name];

  Future get onLoad =>
    Future.wait(_images.values.map((image) => image.onLoad.first));

  void createSprite(String name, String imageName, Point location, Size size) {
    _sprites[name] = new Sprite(image(imageName), location, size);
  }

  Sprite sprite(String name) => _sprites[name];
}