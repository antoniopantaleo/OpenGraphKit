import ArgumentParser
import SwiftUI

@main
struct OpenGraphKit: AsyncParsableCommand {
    
    @MainActor
    mutating func run() async throws {
        try registerFonts()
        guard let scaleFactor =  NSScreen.main?.backingScaleFactor else { return }
        let renderer = ImageRenderer(content: try viewToSnapshot("Hello world"))
        renderer.scale = scaleFactor
        let image = renderer.cgImage
        guard let data = image?.png else { return }
        FileManager.default.createFile(atPath: "myImage.png", contents: data)
        print("✅", "saved")
    }
    
    private func registerFonts() throws {
        guard var fontsUrls = Bundle.module.urls(
            forResourcesWithExtension: nil,
            subdirectory: "Resources/Fonts"
        ) else { fatalError("No fonts found")}
        fontsUrls.removeAll { url in url.lastPathComponent == ".DS_Store" }
        CTFontManagerRegisterFontURLs(fontsUrls as CFArray, .process, false, nil)
    }
    
    func viewToSnapshot(_ title: String) throws -> some View {
        guard
            let imageUrl = Bundle.module.url(forResource: "profile", withExtension: "png"),
            let data = try? Data(contentsOf: imageUrl),
            let nsImage = NSImage(data: data) else { fatalError() }
        return VStack(spacing: 5) {
            Image(nsImage: nsImage)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(title)
                .font(.custom("Inter", size: 40))
                .fontWeight(.bold)
        }
        .frame(width: 1080, height: 720)
        .background(Color.red)
    }
}

fileprivate extension CGImage {
    var png: Data? {
        guard 
            let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(
                mutableData,
                "public.png" as CFString,
                1,
                nil
            )
        else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
