//
//  StatsSectionView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import SwiftUI

struct StatsSectionView: View {
    
    let hp: Int?
    let attack: Int?
    let specialAttack: Int?
    let defense: Int?
    let specialDefense: Int?
    let speed: Int?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                createInfoLabel("HP:")
                createInfoLabel("Attack:")
                createInfoLabel("Special attack:")
                createInfoLabel("Defense:")
                createInfoLabel("Special defense:")
                createInfoLabel("Speed:")
            }
            .padding(.top, 16)
            .padding(.leading, 30)
            
            VStack(alignment: .leading, spacing: 20) {
                createInfoLabel("\(hp ?? 0)", color: .abilityLabelGrey)
                createInfoLabel("\(attack ?? 0)", color: .abilityLabelGrey)
                createInfoLabel("\(specialAttack ?? 0)", color: .abilityLabelGrey)
                createInfoLabel("\(defense ?? 0)", color: .abilityLabelGrey)
                createInfoLabel("\(specialDefense ?? 0)", color: .abilityLabelGrey)
                createInfoLabel("\(speed ?? 0)", color: .abilityLabelGrey)
            }
            .padding(.top, 16)
            .padding(.leading, 50)
            
            Spacer()
        }
    }
    
    // MARK: - Local helper
    private func createInfoLabel(_ text: String, color: UIColor = .black) -> some View {
        Text(text)
            .font(.custom("Lato-Regular", size: 13))
            .foregroundColor(Color(color))
    }
}
