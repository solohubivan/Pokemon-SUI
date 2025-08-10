//
//  RemoteImage.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import SwiftUI

struct RemoteImage: View {
    let urlString: String
    var contentMode: ContentMode = .fit
    var placeholderSize: CGSize? = nil

    var body: some View {
        Group {
            if let url = URL(string: urlString), !urlString.isEmpty {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                } placeholder: {
                    if let size = placeholderSize {
                        ProgressView()
                            .frame(width: size.width, height: size.height)
                    } else {
                        ProgressView()
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}
