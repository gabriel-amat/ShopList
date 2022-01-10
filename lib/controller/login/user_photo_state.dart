enum PhotoState{IDLE, LOADING, ERROR, REMOVED, DONE}

class UserPhotoState{

  PhotoState state;
  String? erroMessage;

  UserPhotoState(this.state, {this.erroMessage});

}