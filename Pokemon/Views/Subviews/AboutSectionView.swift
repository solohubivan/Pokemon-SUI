//
//  AboutSectionView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import SwiftUI

struct AboutSectionView: View {
    
    let height: Int?
    let weight: Int?
    let power: [String]?
    let attack: Int?
    let damage: Int?
    let descriptionText: String?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 25) {
                    createInfoLabel("Height:")
                    createInfoLabel("Weight:")
                    createInfoLabel("Power:")
                    createInfoLabel("Attack:")
                    createInfoLabel("Damage:")
                }
                .padding(.leading, 37)
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 25) {
                    createInfoLabel("\((height ?? 1) * 100) mm", color: .abilityLabelGrey)
                    createInfoLabel("\(Int(weight ?? 1) / 10) kg", color: .abilityLabelGrey)
                    createInfoLabel(formatPowerText(), color: .abilityLabelGrey)
                    formatAttackParameter()
                    createInfoLabel("\(damage ?? 0)", color: .abilityLabelGrey)
                }
                .padding(.leading, 37)
                .padding(.top, 16)

                Spacer()
            }

            Text(descriptionText ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal, 35)
                .font(.custom(AppConstants.Fonts.latoRegular, size: 14))
                .foregroundColor(.black)
        }
    }

    // MARK: - Local helpers
    private func createInfoLabel(_ text: String, color: UIColor = .black) -> some View {
        Text(text)
            .font(.custom(AppConstants.Fonts.latoRegular, size: 13))
            .foregroundColor(Color(color))
    }
    
    private func formatPowerText() -> String {
        guard let power = power, !power.isEmpty else { return "-" }
        return power
            .map { $0.lowercased() }
            .joined(separator: ", ")
    }
    
    private func formatAttackParameter() -> some View {
        let count = (attack ?? 1) / 10
        return HStack(spacing: 4) {
            ForEach(0..<count, id: \.self) { _ in
                Image(AppConstants.ImagesNames.fireSpinIconImage)
            }
        }
    }
}
