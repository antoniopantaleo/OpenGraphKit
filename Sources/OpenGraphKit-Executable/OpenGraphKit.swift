import ArgumentParser
import OpenGraphKit
import SwiftUI

@main
struct OpenGraphKit: AsyncParsableCommand {
    
    @Argument
    private var blogPostPath: String
    @Argument
    private var outputFolder: String
    
    @MainActor
    mutating func run() async throws {
        guard let url = URL(string: blogPostPath, relativeTo: .currentDirectory()) else {
            throw Error(reason: "The file URL can not be found")
        }
        let data = try Data(contentsOf: url)
        try registerFonts(from: .module)
        let (title, quote) = try await BlogParser.parseBlogData(String(decoding: data, as: UTF8.self))
        let imageData = try ThumbnailCreator.createThumbnailImage(title: title, quote: quote)
        let fileName = url.lastPathComponent
        guard let outputFolderURL = URL(string: outputFolder, relativeTo: .currentDirectory()) else { fatalError() }
        FileManager.default.createFile(
            atPath: outputFolderURL.appending(component: fileName.replacingOccurrences(of: ".md", with: ".png")).path(),
            contents: imageData
        )
        print("✅", "saved")
    }
    
    private func registerFonts(from bundle: Bundle) throws {
        guard let fontsUrls = bundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil), !fontsUrls.isEmpty else {
            throw Error(reason: "Unable to find fonts")
        }
        CTFontManagerRegisterFontURLs(fontsUrls as CFArray, .process, false, nil)
    }
}
