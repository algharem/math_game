import 'dart:math';

/// Challenge used to confirm that a grown-up is performing a parent-only
/// action. The factors are outside the multiplication tables the app teaches,
/// and a new challenge is issued after every wrong answer so guessing does not
/// converge.
class ParentGateChallenge {
  const ParentGateChallenge({required this.first, required this.second});

  factory ParentGateChallenge.random([Random? random]) {
    final source = random ?? Random.secure();
    return ParentGateChallenge(
      first: minimumFactor + source.nextInt(maximumFactor - minimumFactor + 1),
      second: minimumFactor + source.nextInt(maximumFactor - minimumFactor + 1),
    );
  }

  static const int minimumFactor = 13;
  static const int maximumFactor = 19;

  final int first;
  final int second;

  int get answer => first * second;

  bool isCorrect(int? value) => value != null && value == answer;
}
