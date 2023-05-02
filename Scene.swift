import SwiftUI

enum Scenes: String, Identifiable, CaseIterable {
    case scene1, scene2

    var id: String { self.rawValue }
}
