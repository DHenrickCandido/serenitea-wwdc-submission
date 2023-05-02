import SwiftUI

class GameManager: ObservableObject {
    @Published var selectedScene = Scenes.scene1
    public let blowDetector = BlowDetector(detectionThreshold: -20)
    func goToScene(_ scene: Scenes) {
        selectedScene = scene
    }
}
