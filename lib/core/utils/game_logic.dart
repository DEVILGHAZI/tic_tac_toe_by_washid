class GameLogic {
  GameLogic._();

  static const List<List<int>> winningCombinations = [
    [0, 1, 2], // Row 1
    [3, 4, 5], // Row 2
    [6, 7, 8], // Row 3
    [0, 3, 6], // Column 1
    [1, 4, 7], // Column 2
    [2, 5, 8], // Column 3
    [0, 4, 8], // Diagonal 1
    [2, 4, 6], // Diagonal 2
  ];

  /// Check if there's a winner
  static List<int>? checkWinner(List<String> board) {
    for (var combination in winningCombinations) {
      final a = board[combination[0]];
      final b = board[combination[1]];
      final c = board[combination[2]];

      if (a.isNotEmpty && a == b && b == c) {
        return combination;
      }
    }
    return null;
  }

  /// Check if the board is full (draw)
  static bool isBoardFull(List<String> board) {
    return board.every((cell) => cell.isNotEmpty);
  }

  /// Check if the game is over
  static bool isGameOver(List<String> board) {
    return checkWinner(board) != null || isBoardFull(board);
  }

  /// Get empty cells indices
  static List<int> getEmptyCells(List<String> board) {
    List<int> emptyCells = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        emptyCells.add(i);
      }
    }
    return emptyCells;
  }

  /// AI Move (Simple algorithm for future enhancement)
  static int getAIMove(List<String> board, String aiPlayer) {
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        List<String> tempBoard = List.from(board);
        tempBoard[i] = aiPlayer;
        if (checkWinner(tempBoard) != null) {
          return i;
        }
      }
    }

    // Second, block opponent from winning
    String opponent = aiPlayer == 'X' ? 'O' : 'X';
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        List<String> tempBoard = List.from(board);
        tempBoard[i] = opponent;
        if (checkWinner(tempBoard) != null) {
          return i;
        }
      }
    }

    // Third, take center if available
    if (board[4].isEmpty) {
      return 4;
    }

    // Fourth, take a corner
    List<int> corners = [0, 2, 6, 8];
    for (int corner in corners) {
      if (board[corner].isEmpty) {
        return corner;
      }
    }

    // Finally, take any available position
    List<int> emptyCells = getEmptyCells(board);
    return emptyCells.isNotEmpty ? emptyCells[0] : -1;
  }

  /// Get winner name
  static String getWinnerName(List<String> board) {
    final winningCombo = checkWinner(board);
    if (winningCombo != null) {
      return board[winningCombo[0]];
    }
    return '';
  }
}
