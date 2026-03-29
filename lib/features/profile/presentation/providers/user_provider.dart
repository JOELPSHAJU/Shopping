import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final String mobile;
  final String dob;

  UserProfile({
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? mobile,
    String? dob,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      dob: dob ?? this.dob,
    );
  }
}

class UserNotifier extends StateNotifier<UserProfile> {
  UserNotifier()
    : super(
        UserProfile(
          name: 'Joel P Shaju',
          email: 'joel@example.com',
          mobile: '+91 8590182736',
          dob: '12 May 1998',
        ),
      );

  void updateProfile(UserProfile profile) {
    state = profile;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserProfile>((ref) {
  return UserNotifier();
});
