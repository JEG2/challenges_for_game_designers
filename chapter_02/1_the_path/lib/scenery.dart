part of the_path;

abstract class Scenery {
  final Game   _game;
  final Screen _screen;

  Point  _location;
  Size   _size;
  String _spriteName;

  Scenery(
    this._game,
    this._screen,
    this._location,
    this._size,
    this._spriteName
  );

  void render(CanvasRenderingContext2D context, num frameDelta) {
    var sprite = _game.assets.sprite(_spriteName);
    context.drawImageScaledFromSource(
        sprite.image,
        sprite.location.x,
        sprite.location.y,
        sprite.size.width,
        sprite.size.height,
        _location.x,
        _location.y,
        _size.width,
        _size.height
    );
  }
}