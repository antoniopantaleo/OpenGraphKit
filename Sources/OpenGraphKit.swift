import ArgumentParser
import SwiftUI

@main
struct OpenGraphKit: AsyncParsableCommand {
    
    @MainActor
    mutating func run() async throws {
        guard let scaleFactor =  NSScreen.main?.backingScaleFactor else { return }
        let renderer = ImageRenderer(content: viewToSnapshot("Hello world"))
        renderer.scale = scaleFactor
        let image = renderer.cgImage
        guard let data = image?.png else { return }
        FileManager.default.createFile(atPath: "myImage.png", contents: data)
        print("✅", "saved")
    }
    
    func viewToSnapshot(_ title: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(title)
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
