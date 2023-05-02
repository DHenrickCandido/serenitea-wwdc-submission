import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var gameManager = GameManager()
    
    let height: CGFloat = 834
    let width: CGFloat = 1194
    
    let red = Double(0xFF) / 255.0
    let green = Double(0xF4) / 255.0
    let blue = Double(0xDF) / 255.0

    
    
    var body: some View {
        let bgColor = Color(red: red, green: green, blue: blue)

        VStack {

            
            switch gameManager.selectedScene {
            case .scene1:
                GeometryReader { geo in
                    var ScaleRateH: CGFloat = geo.size.height / height
                    var ScaleRateW: CGFloat = geo.size.width / width
                    
                    TeaPouringView()
                        .environmentObject(gameManager)
                        .frame(width: width, height: height)
                        .scaleEffect(CGSize(width: ScaleRateW, height: ScaleRateH))
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                        .scaledToFill()

                }
            case .scene2:
                GeometryReader { geo in
                    Text(geo.size.height.description)
                        .frame(maxHeight: .infinity)
                    //                SpriteView(scene: getScene2())
                    
                    Text(geo.size.width.description)
                        .frame(maxHeight: .infinity)
                        .position(x: 500 ,y: 500)
                }
            }
            
            // Exemplo de controle de transição por fora das scenes
//            HStack {
//                Text("Selected: \(gameManager.selectedScene.rawValue)")
//                Spacer()
//                
//                ForEach(Scenes.allCases) { s in
//                    Button(s.rawValue) {
//                        gameManager.selectedScene = s
//                    }
//                }
//            }
//            .padding()
        }.background(bgColor)
    }
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}


}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .previewInterfaceOrientation(.landscapeLeft)
//            
//    }
//}


