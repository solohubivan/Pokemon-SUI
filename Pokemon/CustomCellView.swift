//
//  CustomCellView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 05.08.2025.
//

import SwiftUI

struct CustomCellView: View {
    
    let name: String
    let ability: String
    let imageURL: String
    
    var body: some View {
        ZStack {
            Color.white
            pokemonsInfo
            pokemonsImage
        }
        .cornerRadius(2)
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
    }
        
    // MARK: - UI Components
    private var pokemonsInfo: some View {
        VStack(spacing: 5) {
            nameLabel
            abilityLabel
            Spacer()
        }
        .padding(.leading, 9)
    }
    
    private var nameLabel: some View {
        HStack {
            Text(name.uppercased())
                .font(.custom("Lato-Bold", size: 13))
                .foregroundColor(Color("nameLabelRedColor"))
            Spacer()
        }
        .padding(.top, 32)
    }
    
    private var abilityLabel: some View {
        HStack {
            Text(ability.lowercased())
                .font(.custom("Lato-Regular", size: 11))
                .foregroundColor(Color("abilityLabelGreyColor"))
            
            Spacer()
        }
    }
    
    private var pokemonsImage: some View {
        HStack {
            Spacer()
            pokemonImageView(urlString: imageURL)
        }
        .padding(.top, 32)
    }
    
    // MARK: - Private helpers
    private func pokemonImageView(urlString: String) -> some View {
        Group {
            if let url = URL(string: urlString), !urlString.isEmpty {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .frame(width: 48, height: 48)
                }
            }
        }
    }
}
