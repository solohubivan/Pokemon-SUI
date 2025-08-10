//
//  EvolutionSectionView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//
import SwiftUI

struct EvolutionSectionView: View {
    
    let currentEvolution: String?
    let nextEvolutions: [String]?
    let trigger: String?
    let minLevel: Int?
    let location: String?

    var body: some View {
        VStack(spacing: 20) {
            row("Current evolution:", currentEvolution ?? "")
            row("Next evolution:", nextEvolutionText())
            row("Trigger for next evolution:", triggerText())
            row("Minimal level for evolution:", minLevelText())
            row("Place for next evolution:", locationText())
        }
        .padding(.top, 16)
        .padding(.leading, 30)
    }

    // MARK: - Local helpers
    private func row(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.custom("Lato-Regular", size: 13))
                .foregroundColor(.black)
                .frame(width: 120, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            Text(value)
                .font(.custom("Lato-Regular", size: 13))
                .foregroundColor(Color(.abilityLabelGrey))
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
    
    private func nextEvolutionText() -> String {
        guard let list = nextEvolutions, !list.isEmpty else { return "-" }
        let lowerList = list.map { $0.lowercased() }
        let current = currentEvolution?.lowercased()

        if let current, let idx = lowerList.firstIndex(of: current) {
            if idx == lowerList.count - 1 {
                return "This Pokémon cannot evolve further"
            } else {
                let tail = list[(idx + 1)...]
                return tail.joined(separator: " → ").capitalized
            }
        } else {
            return list.joined(separator: " → ").capitalized
        }
    }
    
    private func shouldShowEvolutionDetails() -> Bool {
        let txt = nextEvolutionText()
        return !(txt == "This Pokémon cannot evolve further" || txt == "-")
    }
    
    private func triggerText() -> String {
        guard shouldShowEvolutionDetails() else { return "-" }
        return trigger?.capitalized ?? "-"
    }

    private func minLevelText() -> String {
        guard shouldShowEvolutionDetails() else { return "-" }
        return minLevel.map(String.init) ?? "-"
    }

    private func locationText() -> String {
        guard shouldShowEvolutionDetails() else { return "-" }
        return location?.capitalized ?? "Unknown Information Yet :("
    }
}
