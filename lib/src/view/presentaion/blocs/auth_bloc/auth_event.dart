part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent { const AuthEvent(); }

class AuthLoaded extends AuthEvent{}

class AuthSignUpEvent extends AuthEvent{
  final BuildContext context;
  final String email;
  final String phone;
  final String password;
  const AuthSignUpEvent({required this.context,required this.email,required this.phone,required this.password});
}

class AuthLoginEvent extends AuthEvent{
  final BuildContext context;
  final String email;
  final String password;
  const AuthLoginEvent({required this.context,required this.email,required this.password});
}

class AuthLogoutEvent extends AuthEvent{
  final BuildContext context;
  const AuthLogoutEvent({required this.context});
}

class AuthDeleteAccout extends AuthEvent{
  final BuildContext context;
  const AuthDeleteAccout({required this.context});
}

class IsUserLogedIn extends AuthEvent{}

class AuthInfoEvent extends AuthEvent{
  final BuildContext context;
  final XFile? image;
  final String name;
  const AuthInfoEvent(this.context,this.image,this.name);
}

// class AuthVeriFyEvent extends AuthEvent{
//   final BuildContext context;
//   final String phone;
//   final String token;
//   const AuthVeriFyEvent({required this.context,required this.phone,required this.token});
// }
