import 'dart:io';

class Contacts {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final File? image;

  Contacts({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.image,
  });
}
