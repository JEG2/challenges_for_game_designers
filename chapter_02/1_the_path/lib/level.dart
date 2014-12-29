part of the_path;

class Level extends Screen {
  static const int  tileWidthAndHeight = 16;
  static const Size tileSize           = const Size(
    tileWidthAndHeight,
    tileWidthAndHeight
  );
  static const int  topTileOffsetCount = 3;

  int              _columns;
  int              _rows;
  Point            inventor;
  Map<Point, bool> _walkable = new Map<Point, bool>();
  int              _moves    = 0;

  Level(_game, template) : super(_game) {
    _parseTemplate(template);
  }

  void render(CanvasRenderingContext2D context, num frameDelta) {
    var offset = tileWidthAndHeight * topTileOffsetCount;
    var scales = [
      (
          _game.width  / (tileWidthAndHeight * _columns         )
      ).floorToDouble(),
      (
          _game.height / (tileWidthAndHeight * _rows    + offset)
      ).floorToDouble()
    ];
    scales.sort();
    var scale          = scales.first;
    var renderedWidth  = (tileWidthAndHeight * _columns)       * scale;
    var renderedHeight = (tileWidthAndHeight * _rows + offset) * scale;

    context.save();
    context.translate(
      (_game.width - renderedWidth) ~/ 2,
      (_game.height - renderedHeight) ~/ 2
    );
    context.scale(scale, scale);
    context.translate(0, offset);
    var inventorDrawn = false;
    _scenery.forEach( (scenery) {
      scenery.render(context, frameDelta);
      if ( !inventorDrawn &&
           (scenery is Bin || scenery is Table) &&
           ( (scenery as Tile).xy.x >= inventor.x &&
             (scenery as Tile).xy.y >= inventor.y ) ) {
        _actors.forEach( (actor) {
          actor.render(context, frameDelta);
        } );
        inventorDrawn = true;
      } else if (!inventorDrawn && (scenery as Tile).xy.y == _rows - 1) {
        _actors.forEach( (actor) {
          actor.render(context, frameDelta);
        } );
        inventorDrawn = true;
      }
    } );
    context.fillStyle = "rgb(255,255,255)";
    context.font      = "12px Georgia, serif";
    context.fillText(_moves.toString(), 4, -(tileWidthAndHeight * 2 + 4));
    context.restore();
  }

  bool canWalkTo(Point xy) {
    var result = _walkable[xy];
    if (result) {
      inventor = xy;
      _moves++;
    }
    return result;
  }

  void _parseTemplate(String template) {
    var backgroundWallsLayer = [ ];
    var floorLayer           = [ ];
    var furnitureLayer       = [ ];
    var blockingWallsLayer   = [ ];

    var rows = template.trim().split("\n");
    for (var y = 0; y < rows.length; y++) {
      _rows     = y + 1;
      var tiles = rows[y].split("");
      for (var x = 0; x < tiles.length; x++) {
        _columns      = x + 1;
        var xy        = new Point(x, y);
        var location  = new Point(
          x * tileWidthAndHeight,
          y * tileWidthAndHeight
        );
        _walkable[xy] = false;
        switch (tiles[x]) {
          case ".":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            _walkable[xy] = true;
            break;
          case "1":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(new Bin(_game, this, xy, location, tileSize));
            break;
          case "2":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(new Bin(_game, this, xy, location, tileSize));
            break;
          case "3":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(new Bin(_game, this, xy, location, tileSize));
            break;
          case "*":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            addActor(new Inventor(_game, this, location, new Size(14, 22)));
            inventor      = new Point(x, y);
            _walkable[xy] = true;
            break;
          case "{":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(
              new Table(_game, this, xy, location, tileSize, "top_left")
            );
            break;
          case "^":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(
              new Table(_game, this, xy, location, tileSize, "top_center")
            );
            break;
          case "}":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(
              new Table(_game, this, xy, location, tileSize, "top_right")
            );
            break;
          case "[":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(
              new Table(_game, this, xy, location, tileSize, "bottom_left")
            );
            break;
          case "v":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(
              new Table(_game, this, xy, location, tileSize, "bottom_center")
            );
            break;
          case "]":
            floorLayer.add(new Floor(_game, this, xy, location, tileSize));
            furnitureLayer.add(
              new Table(_game, this, xy, location, tileSize, "bottom_right")
            );
            break;
          case "`":
            backgroundWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "left",
                "nw_corner"
              )
            );
            break;
          case "(":
            backgroundWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "left",
                "center"
              )
            );
            break;
          case "-":
            if (y == 0) {
              backgroundWallsLayer.add(
                new HorizontalWall(
                  _game,
                  this,
                  xy,
                  location,
                  tileSize,
                  "center",
                  "center"
                )
              );
            } else {
              blockingWallsLayer.add(
                new HorizontalWall(
                  _game,
                  this,
                  xy,
                  location,
                  tileSize,
                  "center",
                  "center",
                  inside: false
                )
              );
            }
            break;
          case "#":
            backgroundWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "center",
                "center",
                window: true
              )
            );
            break;
          case ")":
            backgroundWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "right",
                "center"
              )
            );
            break;
          case "'":
            backgroundWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "right",
                "ne_corner"
              )
            );
            break;
          case "|":
            backgroundWallsLayer.add(
              new VerticalWall(_game, this, xy, location, tileSize)
            );
            break;
          case ",":
            blockingWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "left",
                "sw_corner"
              )
            );
            break;
          case ";":
            blockingWallsLayer.add(
              new HorizontalWall(
                _game,
                this,
                xy,
                location,
                tileSize,
                "right",
                "se_corner"
              )
            );
            break;
        }
      }
    }

    backgroundWallsLayer.forEach( (tile) {
      addScenery(tile);
    } );
    floorLayer.forEach( (tile) {
      addScenery(tile);
    } );
    furnitureLayer.forEach( (tile) {
      addScenery(tile);
    } );
    blockingWallsLayer.forEach( (tile) {
      addScenery(tile);
    } );
  }
}
