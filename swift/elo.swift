import Darwin

/** Holds a player name and Elo rating. */
struct ELOPlayer: Hashable{
  let name: String
  var elo : Int
}

/** Holds a player and information related to the match. */
class EloPlayerResult {
  let player: ELOPlayer
  let placement: Int

  /** The accumulated change in Elo rating over the match. */
  internal(set) var eloChange: Int

  /** Elo rating before the match. */
  var eloPre : Int { return player.elo }

  /** Elo rating after the match. */
  var eloPost: Int { return player.elo + eloChange }

  init(player: ELOPlayer, placement: Int) {
    self.player    = player
    self.placement = placement
    self.eloChange = 0
  }
}

extension EloPlayerResult: Hashable {
  var hashValue: Int {
    return self.player.name.hashValue
  }

  static func == (lhs: EloPlayerResult, rhs: EloPlayerResult) -> Bool {
    return lhs.player.name == rhs.player.name
  }
}

/** Holds the players and their match results. */
class ELOMatch {
  /** All the player results in the match. */
  private(set) var players: Set<EloPlayerResult>

  init(_ results: Set<EloPlayerResult>) {
    self.players = results
    calculateELOs()
  }

  /** Calculate a pairing, apply results to both. */
  private func applyMatchResults(first: EloPlayerResult,
                                 second: EloPlayerResult,
                                 kFactor: Double) {
    guard first != second else { return }

    let qFirst = pow(10.0, Double(first.player.elo) / 400.0)
    let qSecond = pow(10.0, Double(second.player.elo) / 400.0)
    let qDemoninator = qFirst + qSecond

    // Expected scores.
    let expectedFirst = qFirst / qDemoninator
    let expectedSecond = qSecond / qDemoninator

    // Actual score for first player, second is (1 - scoreFirst).
    var scoreFirst: Double

    switch     first.placement {
    case       second.placement: scoreFirst = 0.5 // tie
    case    ..<second.placement: scoreFirst = 1.0 // first won
    default                    : scoreFirst = 0.0 // first lost
    }

    first.eloChange  += Int(round(kFactor * (scoreFirst - expectedFirst)))
    second.eloChange += Int(round(kFactor * (1.0 - scoreFirst - expectedSecond)))
  }

  /** Calculate the match results. */
  private func calculateELOs() {
    let kFactor = 32 / Double(players.count - 1)

    // Pair the opponents.

    for playerIndex in players.indices where playerIndex != players.endIndex {
      let remainder = players.index(after: playerIndex)
      // Skip pairings that have already been done, calculate the rest.
      for second in players[remainder...] {
        applyMatchResults(first: players[playerIndex], second: second, kFactor: kFactor)
      }
    }
  }
}

// Usage:
//
//  let results: Set<EloPlayerResult> = [
//    EloPlayerResult(player: ELOPlayer(name: "Joe", elo: 1612), placement: 1),
//    EloPlayerResult(player: ELOPlayer(name: "Sam", elo: 1554), placement: 2),
//    EloPlayerResult(player: ELOPlayer(name: "Ted", elo: 1515), placement: 3),
//    EloPlayerResult(player: ELOPlayer(name: "Rex", elo: 1428), placement: 4)]
//
//  let match = ELOMatch(results)
//
//  match.players.forEach { (playerResult) in
//    print("\(playerResult.player.name): \(playerResult.eloPost)")
//  }
