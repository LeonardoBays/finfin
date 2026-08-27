enum Preferences {
  deviceUuid('device_uuid'),
  name('name'),
  email('email'),
  jwt('jwt');

  const Preferences(this.value);

  final String value;
}
