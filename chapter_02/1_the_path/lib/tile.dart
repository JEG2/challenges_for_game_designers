part of the_path;

abstract class Tile extends Scenery {
  static final rng = new Random();

  Point xy;

  Tile(_game, _screen, this.xy, _location, _size, _spriteName) :
    super(_game, _screen, _location, _size, _spriteName);
}

class Floor extends Tile {
  Floor(_game, _screen, xy, _location, _size) :
    super(_game, _screen, xy, _location, _size, "floor") {
    if (Tile.rng.nextDouble() <= 0.15) {
      _spriteName = "floor_dirty_${Tile.rng.nextInt(5) + 1}";
    }
  }
}

class Bin extends Tile {
  Bin(_game, _screen, xy, _location, _size) :
    super(_game, _screen, xy, _location, _size, "bin");

  void render(CanvasRenderingContext2D context, num frameDelta) {
    var sprite = _game.assets.sprite(_spriteName);
    context.drawImageScaledFromSource(
        sprite.image,
        sprite.location.x,
        sprite.location.y,
        sprite.size.width,
        sprite.size.height,
        _location.x - (sprite.size.width  - _size.width) / 2,
        _location.y - (sprite.size.height - _size.height),
        sprite.size.width,
        sprite.size.height
    );
  }
}

class Table extends Tile {
  Table(_game, _screen, xy, _location, _size, spriteSuffix) :
    super(_game, _screen, xy, _location, _size, "table_${spriteSuffix}");
}

class HorizontalWall extends Tile {
  final String _topperName;
        String _decorationName;

  HorizontalWall(
    _game,
    _screen,
    xy,
    _location,
    _size,
    spriteSuffix,
    this._topperName,
    {window: false, inside: true}
  ) :
    super(
      _game,
      _screen,
      xy,
      _location,
      _size,
      "wall_horizontal_${spriteSuffix}"
    ) {
    _decorationName = window ? "window" : null;
    if ( spriteSuffix          == "center" &&
         _decorationName       == null     &&
         Tile.rng.nextDouble() <= 0.1 ) {
      if (inside) {
        var choices = ["brick", "plan", "note"];
        _decorationName = choices[Tile.rng.nextInt(3)];
      } else {
        _decorationName = "brick";
      }
    }
  }

  void render(CanvasRenderingContext2D context, num frameDelta) {
    var sprite       = _game.assets.sprite(_spriteName);
    var topperSprite = _game.assets.sprite("topper_${_topperName}");
    context.drawImageScaledFromSource(
        topperSprite.image,
        topperSprite.location.x,
        topperSprite.location.y,
        topperSprite.size.width,
        topperSprite.size.height,
        _location.x,
        _location.y - (sprite.size.height - _size.height) -
                      topperSprite.size.height,
        _size.width,
        _size.height
    );
    context.drawImageScaledFromSource(
        sprite.image,
        sprite.location.x,
        sprite.location.y,
        sprite.size.width,
        sprite.size.height,
        _location.x,
        _location.y - (sprite.size.height - _size.height),
        _size.width,
        sprite.size.height
    );

    if (_decorationName != null) {
      var decoration = _game.assets.sprite("wall_decoration_${_decorationName}");
      context.drawImageScaledFromSource(
          decoration.image,
          decoration.location.x,
          decoration.location.y,
          decoration.size.width,
          decoration.size.height,
          _location.x,
          _location.y - decoration.size.height,
          decoration.size.width,
          decoration.size.height
      );
    }
  }
}

class VerticalWall extends Tile {
  VerticalWall(_game, _screen, xy, _location, _size) :
    super(_game, _screen, xy, _location, _size, "wall_vertical");

  void render(CanvasRenderingContext2D context, num frameDelta) {
    context.translate(0, -(_size.height * 3));
    super.render(context, frameDelta);
    context.translate(0, _size.height * 3);
  }
}
