enum stateButton {IDLE, LOADING}

class ButtonState{
  bool enable;
  bool loading;

  ButtonState({this.loading = false, this.enable = false});
}