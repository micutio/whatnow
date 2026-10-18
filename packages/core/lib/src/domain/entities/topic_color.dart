class TopicColor {
  const TopicColor.rgba(this.r, this.g, this.b, [this.a = 255])
    : assert(r >= 0 && r <= 255, 'Red must be 0-255'),
      assert(g >= 0 && g <= 255, 'Green must be 0-255'),
      assert(b >= 0 && b <= 255, 'Blue must be 0-255'),
      assert(a >= 0 && a <= 255, 'Alpha must be 0-255');

  /// Creates a color from a 32-bit ARGB integer (e.g. 0xFF42A5F5)
  const TopicColor.fromARGB(int value)
    : a = (value >> 24) & 0xFF,
      r = (value >> 16) & 0xFF,
      g = (value >> 8) & 0xFF,
      b = value & 0xFF;

  final int r; // 0 - 255
  final int g; // 0 - 255
  final int b; // 0 - 255
  final int a; // 0 - 255

  /// Returns 32-bit ARGB integer
  int toARGB() => (a << 24) | (r << 16) | (g << 8) | b;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicColor &&
          runtimeType == other.runtimeType &&
          r == other.r &&
          g == other.g &&
          b == other.b &&
          a == other.a;

  @override
  int get hashCode => Object.hash(r, g, b, a);

  static const TopicColor White = TopicColor.rgba(255, 255, 255);
}
