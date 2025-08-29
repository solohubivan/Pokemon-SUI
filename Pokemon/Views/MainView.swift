//
//  MainView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 05.08.2025.
//

import SwiftUI

struct MainView: View {
    
    @State private var viewModel = MainViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                backgroundImage
                contentView
            }
            .task {
                await viewModel.fetchPokemons()
            }
        }
    }
    
    // MARK: - UI Components
    private var backgroundImage: some View {
        Image(AppConstants.ImagesNames.mainViewBackgroundImage)
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
            Text(viewModel.mainTitleText)
                .font(.custom(AppConstants.Fonts.latoBold, size: 24))
                .foregroundColor(Color("titleLabelBlackColor"))
                .padding(.top, 100)
                .padding(.leading, 24)
            Spacer()
        }
    }
    
    private var pokemonsList: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(viewModel.pokemons.enumerated()), id: \.element) { idx, pokemon in
                NavigationLink(
                    destination: DetailPokemonInfoView(choosedPokemon: pokemon)
                ) {
                    CustomCellView(
                        name: pokemon.name,
                        ability: pokemon.abilities?.first ?? "",
                        imageURL: pokemon.imageURL ?? ""
                    )
                    .aspectRatio(1.481, contentMode: .fit)
                }
                .task {
                    if idx >= viewModel.pokemons.count - 3 {
                        await viewModel.fetchPokemons()
                    }
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .frame(height: 60)
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MainView()
}
