part of the_path;

class Inventor extends Actor {
  final Keyboard _keys = new Keyboard();

  Inventor(_game, _screen, _location, _size) :
    super(_game, _screen, _location, _size, "inventor_right");

  Level get _level => _screen as Level;

  void update() {
    var level       = _level;
    var newXY       = null;
    var newLocation = null;
    if (_keys.isDown("up")) {
      newXY       = new Point(level.inventor.x, level.inventor.y - 1);
      newLocation = new Point(_location.x,      _location.y      - 16);
      _spriteName = "inventor_up";
    } else if (_keys.isDown("right")) {
      newXY       = new Point(level.inventor.x + 1,  level.inventor.y);
      newLocation = new Point(_location.x      + 16, _location.y);
      _spriteName = "inventor_right";
    } if (_keys.isDown("down")) {
      newXY       = new Point(level.inventor.x, level.inventor.y + 1);
      newLocation = new Point(_location.x,      _location.y      + 16);
      _spriteName = "inventor_down";
    } else if (_keys.isDown("left")) {
      newXY       = new Point(level.inventor.x - 1,  level.inventor.y);
      newLocation = new Point(_location.x      - 16, _location.y);
      _spriteName = "inventor_left";
    }

    if (newXY != null && level.canWalkTo(newXY)) {
      _location = newLocation;
    }
  }

  void render(CanvasRenderingContext2D context, num frameDelta) {
    var sprite = _game.assets.sprite(_spriteName);
    context.drawImageScaledFromSource(
        sprite.image,
        sprite.location.x,
        sprite.location.y,
        sprite.size.width,
        sprite.size.height,
        _location.x - (sprite.size.width  - Level.tileWidthAndHeight) / 2,
        _location.y - ( sprite.size.height            +
                        Level.tileWidthAndHeight ~/ 4 -
                        Level.tileWidthAndHeight ),
        sprite.size.width,
        sprite.size.height
    );
  }
}
