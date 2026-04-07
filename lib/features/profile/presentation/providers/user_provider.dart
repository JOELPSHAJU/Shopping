import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/features/checkout/presentation/providers/address_provider.dart';

class UserProfile {
  final String name;
  final String email;
  final String mobile;
  final String dob;
  final List<Address> addresses;
  final bool notificationsEnabled;

  UserProfile({
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.addresses,
    this.notificationsEnabled = true,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? mobile,
    String? dob,
    List<Address>? addresses,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      dob: dob ?? this.dob,
      addresses: addresses ?? this.addresses,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
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
            addresses: [
              Address(
                id: '1',
                name: 'Joel P Shaju',
                type: 'Home',
                fullAddress: 'Kinfra Park Main Gate, Accel Infinium 1',
                locality: 'Kazhakkoottam',
                city: 'Thiruvananthapuram',
                state: 'Kerala',
                pincode: '695585',
                mobile: '+91 8590182736',
              ),
            ],
            notificationsEnabled: true,
          ),
        );

  void updateProfile(UserProfile profile) {
    state = profile;
  }

  void updateNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void addAddress(Address address) {
    state = state.copyWith(addresses: [...state.addresses, address]);
  }

  void removeAddress(String id) {
    state = state.copyWith(
      addresses: state.addresses.where((a) => a.id != id).toList(),
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserProfile>((ref) {
  return UserNotifier();
});
