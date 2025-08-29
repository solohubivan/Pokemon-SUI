//
//  RemoteImageView.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    
    let urlString: String?
    var placeholderSize: CGSize? = nil
    var downsampleTo: CGSize = .init(width: 600, height: 600)
    var cornerRadius: CGFloat = 0

    var body: some View {
        Group {
            if let urlStr = urlString,
               !urlStr.isEmpty,
               let url = URL(string: urlStr) {

                KFImage(url)
                    .placeholder {
                        if let size = placeholderSize {
                            ProgressView().frame(width: size.width, height: size.height)
                        } else {
                            ProgressView()
                        }
                    }
                    .setProcessor(DownsamplingImageProcessor(size: downsampleTo))
                    .cacheOriginalImage()
                    .fade(duration: 0.2)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(cornerRadius)

            } else {
                Image("fireSpin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
    }
}
