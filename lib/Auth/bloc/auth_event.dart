part of 'auth_bloc.dart';

abstract class AuthEvent {}

class VerifyAuthEvent extends AuthEvent {}

class AnonymousAuthEvent extends AuthEvent {}

class GoogleAuthEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
