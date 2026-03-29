import 'package:flutter_riverpod/flutter_riverpod.dart';

class Address {
  final String id;
  final String name;
  final String mobile;
  final String pincode;
  final String locality;
  final String fullAddress;
  final String city;
  final String state;
  final String landmark;
  final String type; // 'Home' or 'Work'

  Address({
    required this.id,
    required this.name,
    required this.mobile,
    required this.pincode,
    required this.locality,
    required this.fullAddress,
    required this.city,
    required this.state,
    this.landmark = '',
    required this.type,
  });

  String get summary => '$fullAddress, $locality, $city, $state - $pincode';
}

class AddressState {
  final List<Address> addresses;
  final String? selectedAddressId;

  AddressState({required this.addresses, this.selectedAddressId});

  Address? get selectedAddress {
    if (selectedAddressId == null) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
    return addresses.firstWhere(
      (a) => a.id == selectedAddressId,
      orElse: () => addresses.first,
    );
  }

  AddressState copyWith({List<Address>? addresses, String? selectedAddressId}) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState(addresses: []));

  void addAddress(Address address) {
    state = state.copyWith(
      addresses: [...state.addresses, address],
      selectedAddressId: address.id, // Auto-select the newly added address
    );
  }

  void selectAddress(String id) {
    state = state.copyWith(selectedAddressId: id);
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((
  ref,
) {
  return AddressNotifier();
});
