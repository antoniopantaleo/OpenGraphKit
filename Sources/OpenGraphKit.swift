import ArgumentParser
import SwiftUI

@main
struct OpenGraphKit: AsyncParsableCommand {
    
    @MainActor
    mutating func run() async throws {
        try registerFonts()
        guard let scaleFactor =  NSScreen.main?.backingScaleFactor else { return }
        let renderer = ImageRenderer(content: try viewToSnapshot("Decorator Pattern, a personal favorite"))
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
        return Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
            .frame(width: 1020 * 1.91, height: 1020)
            .overlay {
                HStack(spacing: 80) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 550)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 30) {
                        Text(title)
                            .foregroundStyle(.white)
                            .font(.custom("Inter", size: 130))
                            .fontWeight(.bold)
                        
                        Text("Adding features without touching existing code; is it even possible?")
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.custom("Inter", size: 50))
                            .fontWeight(.light)
                    }
                    
                }
                .padding(50)
            }
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
