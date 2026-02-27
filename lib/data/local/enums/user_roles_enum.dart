enum UserRolesEnum {
  admin,
  cashier
  ;

  static UserRolesEnum fromString(String value) {
    switch (value) {
      case 'admin':
        return UserRolesEnum.admin;
      case 'cashier':
        return UserRolesEnum.cashier;
      default:
        throw Exception('Invalid UserRolesEnum value: $value');
    }
  }
}
