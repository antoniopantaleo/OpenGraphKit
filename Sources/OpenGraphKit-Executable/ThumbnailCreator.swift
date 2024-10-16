//
//  ThumbnailCreator.swift
//
//
//  Created by Antonio on 27/08/24.
//

import Foundation
import SwiftUI

enum ThumbnailCreator {
    
    @MainActor
    static func createThumbnailImage(title: String, quote: String) throws -> Data {
        guard let scaleFactor =  NSScreen.main?.backingScaleFactor else {
            throw OpenGraphKit.Error(reason: "Unable to generate image")
        }
        let profileImage = try getProfileImage()
        let renderer = ImageRenderer(content: view(title: title, quote: quote, image: profileImage))
        renderer.scale = scaleFactor
        let image = renderer.cgImage
        guard let data = image?.png, !data.isEmpty else {
            throw OpenGraphKit.Error(reason: "Unable to generate image data")
        }
        return data
    }
    
    private static func getProfileImage() throws -> NSImage {
        guard
            let imageUrl = Bundle.module.url(forResource: "profile", withExtension: "png"),
            let data = try? Data(contentsOf: imageUrl),
            let nsImage = NSImage(data: data)
        else {
            throw OpenGraphKit.Error(reason: "Unable to load profile image")
        }
        return nsImage
    }
    
    private static func view(
        title: String,
        quote: String,
        image: NSImage
    ) -> some View {
        Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
            .frame(width: 1020 * 1.91, height: 1020)
            .overlay {
                HStack(spacing: 80) {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 550)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 30) {
                        Text(title)
                            .foregroundStyle(.white)
                            .font(.custom("Inter", size: 130))
                            .fontWeight(.bold)
                        Text(quote)
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.custom("Inter", size: 50))
                            .fontWeight(.light)
                    }
                }
                .padding(50)
            }
    }
}
