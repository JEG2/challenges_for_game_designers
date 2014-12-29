part of the_path;

abstract class Actor extends Scenery {
  Actor(_game, _screen, _location, _size, _spriteName) :
    super(_game, _screen, _location, _size, _spriteName);

  void update();
}