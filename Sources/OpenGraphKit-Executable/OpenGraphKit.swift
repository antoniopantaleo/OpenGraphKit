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
        try registerFonts()
        let (title, quote) = try await BlogParser.parseBlogData(String(data: data, encoding: .utf8)!)
        let imageData = try ThumbnailCreator.createThumbnailImage(title: title, quote: quote)
        let fileName = url.lastPathComponent
        guard let outputFolderURL = URL(string: outputFolder, relativeTo: .currentDirectory()) else { fatalError() }
        FileManager.default.createFile(
            atPath: outputFolderURL.appending(component: fileName.replacingOccurrences(of: ".md", with: ".png")).path(),
            contents: imageData
        )
        print("✅", "saved")
    }
    
    private func registerFonts() throws {
        guard var fontsUrls = Bundle.module.urls(
            forResourcesWithExtension: nil,
            subdirectory: "Resources/Fonts"
        ) else { throw Error(reason: "Unable to find fonts") }
        fontsUrls.removeAll { url in url.lastPathComponent == ".DS_Store" }
        CTFontManagerRegisterFontURLs(fontsUrls as CFArray, .process, false, nil)
    }
    
}
