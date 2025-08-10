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
                .font(.custom(AppConstants.Fonts.latoBold, size: 13))
                .foregroundColor(Color("selectedRedColor"))
            Spacer()
        }
        .padding(.top, 32)
    }
    
    private var abilityLabel: some View {
        HStack {
            Text(ability.lowercased())
                .font(.custom(AppConstants.Fonts.latoRegular, size: 11))
                .foregroundColor(Color("abilityLabelGreyColor"))
            
            Spacer()
        }
    }
    
    private var pokemonsImage: some View {
        HStack {
            Spacer()
            RemoteImageView(urlString: imageURL)
        }
        .padding(.top, 32)
    }
}
