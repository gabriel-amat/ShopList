enum stateLogin{IDLE, LOADING, ERROR, LOGGED, ANONYMOUS}

class LoginState{

  stateLogin? state;
  String? errorMsg;

  LoginState(this.state, {this.errorMsg});

}