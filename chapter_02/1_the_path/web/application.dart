import "dart:math";

import "package:the_path/the_path.dart";

void main() {
  var level1_template = """
`(-#---#-)'
|.1.2.2.3.|
|*........|
|...{^}...|
|...[v]...|
|.........|
|.........|
|.........|
,---------;
""";

  var game = new Game("#game", (game) => new Level(game, level1_template));

  game.assets.loadImage("sprites", "images/sprite_sheet.png");
  game.assets.createSprite(
    "floor",
    "sprites",
    new Point(32, 64),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "floor_dirty_1",
    "sprites",
    new Point(64, 48),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "floor_dirty_2",
    "sprites",
    new Point(80, 48),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "floor_dirty_3",
    "sprites",
    new Point(64, 64),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "floor_dirty_4",
    "sprites",
    new Point(80, 64),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "floor_dirty_5",
    "sprites",
    new Point(64, 80),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "bin",
    "sprites",
    new Point(78, 149),
    new Size(20, 26)
  );
  game.assets.createSprite(
    "table_top_left",
    "sprites",
    new Point(16, 103),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "table_top_center",
    "sprites",
    new Point(32, 103),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "table_top_right",
    "sprites",
    new Point(48, 103),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "table_bottom_left",
    "sprites",
    new Point(16, 135),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "table_bottom_center",
    "sprites",
    new Point(32, 135),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "table_bottom_right",
    "sprites",
    new Point(48, 135),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "wall_horizontal_left",
    "sprites",
    new Point(32, 0),
    new Size(16, 48)
  );
  game.assets.createSprite(
    "wall_horizontal_center",
    "sprites",
    new Point(48, 0),
    new Size(16, 48)
  );
  game.assets.createSprite(
    "wall_horizontal_right",
    "sprites",
    new Point(64, 0),
    new Size(16, 48)
  );
  game.assets.createSprite(
    "wall_vertical",
    "sprites",
    new Point(128, 16),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "topper_nw_corner",
    "sprites",
    new Point(144, 0),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "topper_ne_corner",
    "sprites",
    new Point(176, 0),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "topper_center",
    "sprites",
    new Point(160, 48),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "topper_sw_corner",
    "sprites",
    new Point(144, 32),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "topper_se_corner",
    "sprites",
    new Point(176, 32),
    new Size(16, 16)
  );
  game.assets.createSprite(
    "wall_decoration_window",
    "sprites",
    new Point(96, 12),
    new Size(16, 20)
  );
  game.assets.createSprite(
    "wall_decoration_brick",
    "sprites",
    new Point(81, 17),
    new Size(14, 14)
  );
  game.assets.createSprite(
    "wall_decoration_plan",
    "sprites",
    new Point(81, 33),
    new Size(14, 14)
  );
  game.assets.createSprite(
    "wall_decoration_note",
    "sprites",
    new Point(97, 33),
    new Size(14, 14)
  );
  game.assets.createSprite(
    "inventor_down",
    "sprites",
    new Point(17, 201),
    new Size(14, 22)
  );
  game.assets.createSprite(
    "inventor_up",
    "sprites",
    new Point(17, 233),
    new Size(14, 22)
  );
  game.assets.createSprite(
    "inventor_left",
    "sprites",
    new Point(17, 265),
    new Size(14, 22)
  );
  game.assets.createSprite(
    "inventor_right",
    "sprites",
    new Point(17, 297),
    new Size(14, 22)
  );

  game
    ..center()
    ..start();
}
