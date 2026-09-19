class Streak {
  const Streak({
    this.current = 0,
    this.longest = 0,
    this.lastReadDate,
  });

  final int current;
  final int longest;
  final DateTime? lastReadDate;
}
