class Limit {
  final int skip, take;

  const Limit(this.skip, this.take);

  factory Limit.unlimited() => Limit(0, -1);
  factory Limit.paginated(int page, int pageSize) => Limit((page -1) * pageSize, pageSize);
  factory Limit.take(int amount) => Limit(0, amount);

  Map<String, dynamic> toJson() {
    return {
      "skip": skip,
      "take": take
    };
  }
}