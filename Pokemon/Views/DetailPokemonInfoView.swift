//
//  DetailPokemonInfoView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 06.08.2025.
//

import SwiftUI

struct DetailPokemonInfoView: View {
    
    let choosedPokemon: Pokemon
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = DetailPokemonInfoViewModel()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            navigationBar
            contentView
        }
        .onAppear {
            viewModel.configure(with: choosedPokemon)
        }
    }
    
    // MARK: - UI Components
    private var navigationBar: some View {
        Color.clear
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("leftArrow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                }
            }
    }
    
    private var contentView: some View {
        VStack {
            nameLabel
            mainImage
            modeButtonsStack
            modeContentView
            Spacer()
        }
    }
    
    private var nameLabel: some View {
        HStack {
            Text(viewModel.pokemon?.name.capitalized ?? "")
                .font(.custom("Lato-Bold", size: 24))
                .foregroundColor(Color("titleLabelBlackColor"))
                .padding(.leading, 24)
                .padding(.top, 32)
            Spacer()
        }
    }
    
    private var mainImage: some View {
        RemoteImage(urlString: viewModel.pokemon?.imageURL ?? "")
            .frame(height: 200)
            .padding(.top, 40)
    }
    
    private var modeButtonsStack: some View {
        ZStack(alignment: .bottom) {
            underscoreLine

            HStack {
                Spacer()
                ForEach(PokemonDetailInfoMode.allCases) { mode in
                    createModeButton(
                        title: mode.rawValue,
                        color: viewModel.selectedMode == mode ? Color("selectedRedColor") : Color.black,
                        font: .custom("Lato-Regular", size: 14),
                        isActive: viewModel.selectedMode == mode
                    ) {
                        viewModel.selectedMode = mode
                    }
                    Spacer()
                }
            }
            .padding(.top, 16)
        }
        .padding(.top, 16)
    }
    
    private var underscoreLine: some View {
        Rectangle()
            .fill(Color("unselectedModeLineColor"))
            .frame(height: 1)
            .padding(.horizontal, 24)
            .padding(.top, 0)
    }
    
    @ViewBuilder
    private var modeContentView: some View {
        switch viewModel.selectedMode {
        case .about:
            aboutView
        case .stats:
            statsView
        case .evolution:
            evolutionView
        case .moves:
            movesView
        }
    }
    
    private var aboutView: some View {
        AboutSectionView(
            height: viewModel.pokemon?.height,
            weight: viewModel.pokemon?.weight,
            power: viewModel.pokemon?.abilities,
            attack: viewModel.pokemon?.attack,
            damage: viewModel.pokemon?.damage,
            descriptionText: viewModel.pokemon?.description
        )
    }
    
    private var statsView: some View {
        StatsSectionView(
            hp: viewModel.pokemon?.hp,
            attack: viewModel.pokemon?.attack,
            specialAttack: viewModel.pokemon?.specialAttack,
            defense: viewModel.pokemon?.defense,
            specialDefense: viewModel.pokemon?.specialDefense,
            speed: viewModel.pokemon?.speed
        )
    }
    
    private var evolutionView: some View {
        EvolutionSectionView(
            currentEvolution: viewModel.pokemon?.name.capitalized,
            nextEvolutions: viewModel.pokemon?.nextEvolutions,
            trigger: viewModel.pokemon?.evolutionTrigger,
            minLevel: viewModel.pokemon?.minLevel,
            location: viewModel.pokemon?.evolutionLocation
        )
    }
    
    private var movesView: some View {
        MovesSectionView(moves: viewModel.pokemon?.moves)
    }
    
    // MARK: - Helpers
    private func createModeButton(title: String, color: Color, font: Font, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(font)
                    .foregroundColor(color)
                if isActive {
                    Rectangle()
                        .fill(color)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, -10)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 1)
                }
            }
            .fixedSize()
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    DetailPokemonInfoView(pokemon: Pokemon(name: "Huy", url: ""))
//}
