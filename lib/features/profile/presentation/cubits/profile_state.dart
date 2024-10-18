/*

  PROFILE STATES

 */

abstract class ProfileState{}

  // initial
class ProfileInitial extends ProfileState{}

  // loading
class ProfileLoading extends ProfileState{}

  // loaded
class ProfileLoaded extends ProfileState{}

  // error
class ProfileError extends ProfileState{}