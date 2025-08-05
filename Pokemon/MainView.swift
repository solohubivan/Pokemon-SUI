//
//  MainView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 05.08.2025.
//

import SwiftUI

struct MainView: View {
    
    let items = (1...25)
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            backgroundImage
            contentView
        }
    }
    
    // MARK: - UI Components
    private var backgroundImage: some View {
        Image("backgroundImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                titleLabel
                pokemonsList
            }
        }
    }
    
    private var titleLabel: some View {
        HStack {
            Text("Know Them All")
                .font(.custom("Lato-Bold", size: 24))
                .foregroundColor(Color("titleLabelBlackColor"))
                .padding(.top, 100)
                .padding(.leading, 24)
            Spacer()
        }
    }
    
    private var pokemonsList: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items, id: \.self) { num in
                CustomCellView()
                    .aspectRatio(1.481, contentMode: .fit)
                    .onTapGesture {
                        print("Обрана ячейка №\(num)")
                    }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MainView()
}
