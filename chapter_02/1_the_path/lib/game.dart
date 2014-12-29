part of the_path;

typedef Screen GameInitializer(Game game);

class Game {
  static const millisecondsPerUpdate = 16;

  CanvasElement            _canvas;
  int                      width;
  int                      height;
  CanvasRenderingContext2D _context;

  final AssetManager assets = new AssetManager();

  Screen screen;

  num lastTimestamp;

  String _status = "Loading";

  Game(String canvasSelector, GameInitializer initializer) {
    _canvas  = querySelector(canvasSelector);
    width    = _canvas.width;
    height   = _canvas.height;
    _context = _canvas.getContext("2d");

    screen = initializer(this);
  }

  bool get isLoading => _status == "Loading";
  bool get isRunning => _status == "Running";

  void center() {
    var marginToCenter      = ((window.innerHeight - height) / 2).toInt();
    _canvas.style.marginTop = "${marginToCenter}px";
  }

  void start() {
    assets.onLoad.then( (_) {
      _status = "Running";
      tick();
    } );
  }

  void tick([int timestamp]) {
    var elapsed   = lastTimestamp != null ? timestamp - lastTimestamp
                                          : millisecondsPerUpdate;
    lastTimestamp = timestamp;

    while (elapsed >= millisecondsPerUpdate) {
      screen.update();
      elapsed -= millisecondsPerUpdate;
    }

    screen.render(_context, elapsed / millisecondsPerUpdate);

    window.animationFrame.then(tick);
  }
}
