part of the_path;

abstract class Screen {
  final Game _game;

  final List<Scenery> _scenery     = new List<Scenery>();
  final List<Actor>   _actors      = new List<Actor>();
  final List<Actor>   _actorsToAdd = new List<Actor>();

  Screen(this._game);

  void addScenery(Scenery scenery) {
    _scenery.add(scenery);
  }

  void addActor(Actor actor) {
    _actors.add(actor);
  }

  void addActorLater(Actor actor) {
    _actorsToAdd.add(actor);
  }

  void update() {
    _actors.forEach( (actor) {
      actor.update();
    } );
    if (!_actorsToAdd.isEmpty) {
      _actors.addAll(_actorsToAdd);
      _actorsToAdd.clear();
    }
  }

  void render(CanvasRenderingContext2D context, num frameDelta) {
    _scenery.forEach( (scenery) {
      scenery.render(context, frameDelta);
    } );
    _actors.forEach( (actor) {
      actor.render(context, frameDelta);
    } );
  }
}
