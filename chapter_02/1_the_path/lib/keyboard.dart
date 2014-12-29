part of the_path;

class Keyboard {
  static const Map<String, int> keyCodes =
    const {"left": 37, "up": 38, "right": 39, "down": 40};

  final Map<int, bool> _down = new Map<int, bool>();

  Keyboard() {
    keyCodes.values.forEach( (keyCode) {
      _down[keyCode] = false;
    } );

    window.onKeyDown.listen( (event) {
      _down[event.keyCode] = true;
    } );
    window.onKeyUp.listen( (event) {
      _down[event.keyCode] = false;
    } );
  }

  bool isDown(keyName) {
    var keyCode = keyCodes[keyName];
    var result  = _down[keyCode];
    if (result) {
      _down[keyCode] = false;
    }
    return result;
  }
}
