//
//  AsyncImage.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 14/09/26.
//

import SwiftUI

struct AsyncImageComponent: View {
    var thumbnail: String
    var size : Double
    var body: some View {
        AsyncImage(
            url: URL(string: thumbnail)
        ) { phase in

            switch phase {

            case .empty:
                ProgressView()

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)

            @unknown default:
                EmptyView()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        }
}


