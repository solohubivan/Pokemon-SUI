//
//  MovesSectionView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import SwiftUI

struct MovesSectionView: View {
    
    let moves: [String]?
    
    var body: some View {
        ScrollView {
            Text("There are available moves:")
                .font(.custom(AppConstants.Fonts.latoSemibold, size: 16))
                .foregroundColor(.black)
                
            Text(joinedMoves())
                .font(.custom(AppConstants.Fonts.latoRegular, size: 14))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.top, 2)
        }
    }
    
    // MARK: - Helpers
    private func joinedMoves() -> String {
        guard let moves, !moves.isEmpty else {
            return "-"
        }
        return moves.joined(separator: ", ").capitalized
    }
}
