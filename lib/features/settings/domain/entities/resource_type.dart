/// Represents the type of media attached to a message.
enum ResourceType {
  track('TRACK'),
  playlist('PLAYLIST');

  const ResourceType(this.value);
  final String value;
}
