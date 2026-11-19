class UserSettings {
  String name;
  String address;
  String email;
  String patronNumber;
  bool receiveNewsletter;

  UserSettings({
    this.name = '',
    this.address = '',
    this.email = '',
    this.patronNumber = '',
    this.receiveNewsletter = false,
  });
}
