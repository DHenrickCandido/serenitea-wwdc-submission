import SwiftUI
import CoreMotion
import AVFoundation



let motionManagerCup = CMMotionManager()
let motionQueueCup = OperationQueue()
let motionManager = CMMotionManager()
let motionQueue = OperationQueue()

var audioLofi: AVAudioPlayer? = nil
var audioSounds: AVAudioPlayer? = nil
var audioSip: AVAudioPlayer? = nil
var audioFogao: AVAudioPlayer? = nil

enum GameStatus {
    case menuInicial
    case escolhaChaFalas
    case escolhaCha
    case aguaNoFogo
    case aguaNoFogoComSucesso
    case selecionarTeapot
    case teaPouring
    case drinkTea
    case blow
    case menuFinal
    
    
    var blurValue: Double{
        if self == .teaPouring || self == .drinkTea || self == .escolhaCha || self == .drinkTea || self == .blow
        {
            return 10
        } else {
            return 0
        }
    }
    
    var objectsTeaPouring: Bool {
        return self == .teaPouring
    }
    
    var background: String {
        if self == .menuInicial
        {
            return "menu-inicial"
        }
        else if self == .menuFinal
        {
            return "menu-final"
        }
        else {
            return "bg-kitchen"
        }
        
        
    }
}

struct TeaPouringView: View {
    @State var rotation = 0.0
    @State var rotationCup = 0.0
    @State var imageCup = "cupGreen0"
    
    @State var imageTeapot = "teapot"
    @State var timeElapsed = 0.0
    @State var timeFogao = 0.0
    @State var tocandoTea = 0
    // the variable that controls THE SCENES - this was awesome to debug, cause i could select the scene hehe
    @State var status = GameStatus.menuInicial
    @EnvironmentObject var gameManager: GameManager
    
    @State var cha_escolhido = "green-tea"
    
    
    @State var isBlinkingTeapot = false
    @State var isDragging: CGSize = CGSize.zero
    
    @State var teapotPosX = 600.0
    @State var teapotPosY = 480.0
    @State var fogaoPosX = 430.0
    @State var fogaoPosY = 500.0
    
    @State var collision = false
    var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var timerBlow = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    // A LOT OF FLAGS RIGHT? I know i can make it better next time but im proud of myself
    @State var opacityFogo = 0.0
    @State var timeElapsedBeberCha = 0.0
    @State var jabebeu = 0
    
    @State var falasPos = 1
    
    @State var timeElapsedBlow = 0.0
    @State var preEscolhaChaWhite = 1.0
    @State var preEscolhaChaGreen = 1.0
    @State var preEscolhaChaHerbal = 1.0
    @State var falando = true
    @State var mostrando = 1.0
    @State var sips = 0
    @State var warning = "warning1"
    @State var jaEncheu = false
    @State var zPositionCup: Double = 10
    @State var selecionadoWhite: CGFloat = 0
    @State var selecionadoGreen: CGFloat = 0
    @State var selecionadoHerbal: CGFloat = 0
    @State var mostrarWarning4 = 0.0
    @State var mostrarWarning0 = 0.0
    @State var mostrarWarning2 = 0.0
    @State var blinkCupTeaPouring: CGFloat = 1.0

    @State var mostrandoOpisca = false
    @State var background = "menu-final-green"

        var body: some View {
        HStack{
            if status == .menuFinal{
                Image("")
                    .resizable()
                    .frame(width: 510, height: 140)
                    .position(x: 600, y: 325)
                    .onAppear(){
                        if status == .menuInicial
                        {
                            background =  "menu-inicial"
                        }
                        else if status == .menuFinal && cha_escolhido == "green-tea"
                        {
                            background = "menu-final-green"
                        }
                        else if status == .menuFinal && cha_escolhido == "white-tea"
                        {
                            background = "menu-final-white"
                        }

                        else if status == .menuFinal && cha_escolhido == "herbal-tea"
                        {
                            background = "menu-final-herbal"
                        }

                        else {
                            background = "bg-kitchen"
                        }
                    }
            }
            if status == .menuInicial {
                Image("start-button")
                    .resizable()
                    .frame(width: 380, height: 140)
                    .position(x: 600, y: 655)
                    .onTapGesture {
                        status = .escolhaCha
                    }
                    .onAppear(){
                        if status == .menuInicial
                        {
                            background =  "menu-inicial"
                        }
                        else if status == .menuFinal && cha_escolhido == "green-tea"
                        {
                            background = "menu-final-green"
                        }
                        else if status == .menuFinal && cha_escolhido == "white-tea"
                        {
                            background = "menu-final-white"
                        }

                        else if status == .menuFinal && cha_escolhido == "herbal-tea"
                        {
                            background = "menu-final-herbal"
                        }

                        else {
                            background = "bg-kitchen"
                        }
                    }
                
            }
            if status == .blow {
                var nameFala = "fala"+String(falasPos)
                
                Image(nameFala)
                    .resizable()
                    .frame(width: 1100, height: 300)
                    .position(x: 590, y: 130)
                    .opacity(mostrando)
                    .onTapGesture {
                        
                        if falasPos >= 18 {
                            falasPos += 1
                            if falasPos >= 19{
                                falasPos = 19
                                falando = false
                                mostrarWarning2 = 1.0
                            }
                            
                        }
                        
                    }
                    .onAppear(){
                        mostrarWarning2 = 0.0
                        falando = true
                        falasPos = 18
                    }
                Image(imageCup)
                    .resizable()
                    .frame(width: 600, height: 400)
                    .position(x: 310, y: 560)
                    .onTapGesture {
                        
                    }
                    .onAppear(){
                        if cha_escolhido == "green-tea"
                        {
                            self.imageCup = "cupGreen"
                        }
                        else if cha_escolhido == "white-tea"
                        {
                            self.imageCup = "cupBranco"
                        }
                        else if cha_escolhido == "herbal-tea"
                        {
                            self.imageCup = "cupErva"
                        }
                        
                        

                    }
                    .onReceive(timerBlow) { _ in
                        if !falando{
                            print("lendo")
                            
//                            gameManager.blowDetector.startDetecting()

                            if gameManager.blowDetector.detectedBlow()
                            {
                                print(timeElapsedBlow)
                                timeElapsedBlow += 1
                                if timeElapsedBlow >= 4{
                                    
                                    print("SOPROU MANOO")
                                    status = .drinkTea
                                }
                            }

                        }
                    }
                Image("fumassa")
                    .resizable()
                    .frame(width: 200, height: 180)
                    .position(x: -20, y: 350)
                    .opacity(isBlinkingTeapot ? 0.4 : 1.0)
                // aaah this warning aaaaah, I made one with the newer way but was too late to change all the others, sometimes we have to prioritize i guess
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
                    .onAppear(){
                        withAnimation {
                            isBlinkingTeapot.toggle()
                        }
                    }
                
                GeometryReader { geo in
                    Image("warning2")
                        .resizable()
                        .frame(width: 154.5, height: 85)
                        .position(x: -(geo.size.width)*2.3, y: (geo.size.height)*0.6)
                        .animation(.easeInOut(duration: 0.5))
                        .opacity(mostrarWarning2)
                }
            }
            if status == .drinkTea {
                var nameFala = "fala"+String(falasPos)
                GeometryReader { geo in
                    Image("warning1")
                        .resizable()
                        .frame(width: 154.5, height: 85)
                        .position(x: (geo.size.width/2), y: (geo.size.height)/2)
                }

                Image(nameFala)
                    .resizable()
                    .frame(width: 1100, height: 300)
                    .position(x: 190, y: 130)
                    .opacity(mostrando)
                    .onTapGesture {
                        if !falando {
                            if timeElapsedBeberCha >= 10.0 && status == .drinkTea
                            {
                                jabebeu = 0
                                timeElapsedBeberCha = 0.0
                                status = .menuFinal
                            }
                        }
                        
                        
                    }
                    .onAppear(){
                        falando = true
                        falasPos = 20
                    }
                Image(imageCup)
                    .resizable()
                    .rotationEffect(.degrees(rotationCup), anchor: .center)

                    .frame(width: 600, height: 400)
                    .position(x: -150, y: 500)
                    .onTapGesture {

                        
                    }
                    .onAppear(){
                        if cha_escolhido == "green-tea"
                        {
                            self.imageCup = "cupGreen"
                        }
                        else if cha_escolhido == "white-tea"
                        {
                            self.imageCup = "cupBranco"
                        }
                        else if cha_escolhido == "herbal-tea"
                        {
                            self.imageCup = "cupErva"
                        }

                        if let audioFileURL = Bundle.main.url(forResource: "sip", withExtension: "mp3") {
                            do {
                                audioSip = try AVAudioPlayer(contentsOf: audioFileURL)
                                audioSip?.prepareToPlay()

                            } catch {
                                print("Não foi possível reproduzir a música.")
                            }
                        } else {
                            print("O arquivo de áudio não foi encontrado.")
                        }

                        // i could never imagine that this would work on the first try, IM AMAZING
                        motionManagerCup.startDeviceMotionUpdates(to: motionQueueCup) { (data, error) in
                            guard let data = data else {
                                print("Error: \(error!)")
                                return
                            }

                            let xRotation = data.attitude.roll * 180 / Double.pi
                            let yRotation = data.attitude.pitch * 180 / Double.pi
                            let zRotation = data.attitude.yaw * 180 / Double.pi


                                print(yRotation)
                            if (yRotation < -25 && status == .drinkTea && jabebeu == 0) || (yRotation > 25 && status == .drinkTea && jabebeu == 0) {

                                timeElapsedBeberCha += 0.1
                                print(timeElapsedBeberCha)
                                print(sips)
                                print(falasPos)
                                if timeElapsedBeberCha >= 10.0 && sips == 0 {
                                    audioSip?.play()

                                    falasPos = 21
                                    sips = 1
                                }
                                
                                if timeElapsedBeberCha >= 50.0 && sips == 1 {
                                    audioSip?.play()
                                    falasPos = 22
                                    sips = 2
                                }
                                
                                if timeElapsedBeberCha >= 80.0 && sips == 2 {
                                    audioSip?.play()
                                    falasPos = 23

                                    if cha_escolhido == "green-tea"
                                    {
                                        self.imageCup = "cupGreen0"
                                    }
                                    else if cha_escolhido == "white-tea"
                                    {
                                        self.imageCup = "cupBranco0"
                                    }
                                    else if cha_escolhido == "herbal-tea"
                                    {
                                        self.imageCup = "cupErva0"
                                    }
                                    jabebeu = 1
                                    falando = false

                                }
                                else{

                                }
                            } else
                            {
                                DispatchQueue.main.async {
                                    rotationCup = yRotation

                                }
                            }

                        }
                        GeometryReader { geo in
                            Image("warning2")
                                .resizable()
                                .frame(width: 154.5, height: 85)
                                .position(x: (geo.size.width/4), y: (geo.size.height)/2)
                        }
                    }




            }
            if status == .aguaNoFogoComSucesso{
                Image("teapot-small")
                    .position(x: 958, y: 460)
                    .onAppear() {
                    }
                    .onReceive(timer) { _ in
                        timeFogao += 1
                        print(timeFogao)
                        if timeFogao == 2{
                            opacityFogo = 1.0
                        }
                        if timeFogao == 8{
                            status = .selecionarTeapot
                            audioFogao?.stop()
                        }
                    }
                    .animation(.easeInOut(duration: 0.5))

                Image("fogo")
                    .resizable()
                    .frame(width: 80, height: 20)
                    .position(x: 365, y: 495)
                    .onAppear(){
                        // the sound is SO comfi :)
                        if let audioFileURL = Bundle.main.url(forResource: "fogao", withExtension: "wav") {
                            do {
                                audioFogao = try AVAudioPlayer(contentsOf: audioFileURL)
                                audioFogao?.numberOfLoops = -1
                                audioFogao?.prepareToPlay()

                                
                            } catch {
                                print("Não foi possível reproduzir a música.")
                            }
                        } else {
                            print("O arquivo de áudio não foi encontrado.")
                        }
                        audioFogao?.volume = 1
                        audioFogao?.prepareToPlay()
                        audioFogao?.play()
                        
                    }
                    .opacity(opacityFogo)
                    .animation(.easeInOut(duration: 0.5))
            }
            if status == .aguaNoFogo{
                
                var nameFala = "fala"+String(falasPos)
                var escolhaChaFalaPos: Int {
                    if cha_escolhido == "white-tea" {
                        return 8
                    } else if cha_escolhido == "green-tea" {
                        return 9
                    } else if cha_escolhido == "herbal-tea" {
                        return 10
                    }
                    return 8
                }
                Image(nameFala)
                    .resizable()
                    .frame(width: 1100, height: 300)
                    .position(x: 590, y: 130)
                    .opacity(mostrando)
                    .onTapGesture {
                        if falasPos <= 10{
                            print(falasPos)
                            falasPos = 11
                        } else if falasPos >= 11 {
                            falasPos += 1
                            if falasPos >= 12{
                                falasPos = 12
                                mostrarWarning4 = 1.0
                                falando = false
                            }
                            
                        }
                        
                    }
                    .onAppear(){
                        falando = true
                        falasPos = escolhaChaFalaPos
                        
                    }
                Image("teapot-small")
                    .position(x: 210, y: 480)
                    .onTapGesture {

                    }
                
                    .offset(x: isDragging.width, y: isDragging.height)
                    .gesture(
                        
                        DragGesture()
                            .onChanged { value in
                                if !falando{
                                    mostrando = 0.0
                                    self.teapotPosX = value.location.x
                                    self.teapotPosY = value.location.y

                                    isDragging = value
                                        .translation
                                }
                                
                            }
                            .onEnded { value in
                                if !falando{

                                    mostrando = 1.0
                                    checkCollision()
                                    
                                    withAnimation(.spring()) {
                                        isDragging = .zero
                                        
                                    }
                                }
                                
                            }
                    )
                    .zIndex(10)

                    
                GeometryReader { geo in
                    Image("warning4")
                        .resizable()
                        .frame(width: 154.5, height: 85)
                        .position(x: -(geo.size.width)*0.8, y: (geo.size.height)*0.55)
                        .opacity(mostrarWarning4)
                        
                }

            }
            if status == .escolhaCha{
                var nameFala = "fala"+String(falasPos)
                

                
                var opacity: Double {
                    if falando {
                        return 1.0
                    } else {
                        return 0.0
                    }
                }
                
                Image(nameFala)
                    .resizable()
                    .frame(width: 1100, height: 300)
                    .position(x: 590, y: 130)
                    .opacity(1.0)

                    .onTapGesture {
                        if falasPos <= 2{
                            falasPos += 1
                            if falasPos == 3 {
                                falasPos = 3
                                falando = false
                            }
                        }
                        print(preEscolhaChaHerbal)
                        print(preEscolhaChaGreen)
                        print(preEscolhaChaWhite)
                        print(falasPos)
                    }
                    .onAppear(){
                        if status == .menuInicial
                        {
                            background =  "menu-inicial"
                        }
                        else if status == .menuFinal && cha_escolhido == "green-tea"
                        {
                            background = "menu-final-green"
                        }
                        else if status == .menuFinal && cha_escolhido == "white-tea"
                        {
                            background = "menu-final-white"
                        }

                        else if status == .menuFinal && cha_escolhido == "herbal-tea"
                        {
                            background = "menu-final-herbal"
                        }

                        else {
                            background = "bg-kitchen"
                        }
                    }

                
                Image("white-tea")
                    .resizable()
                    .frame(width: 220, height: 290)
                    .position(x: 0, y: 500-selecionadoWhite)
                    .animation(.easeInOut(duration: 0.5))
                    .onTapGesture {
                        if !falando{
                            if preEscolhaChaWhite == 1.0{
                                selecionadoWhite = 50
                                selecionadoGreen = 0
                                selecionadoHerbal = 0
                                preEscolhaChaWhite = 0.7
                                preEscolhaChaHerbal = 1.0
                                preEscolhaChaGreen = 1.0
                                falasPos = 4
                                print(selecionadoWhite)
                                print(selecionadoGreen)
                                print(selecionadoHerbal)
                            }
                                
                            else {
                                cha_escolhido = "white-tea"
                                status = .aguaNoFogo
                                falando = false
                                falasPos = 7
                            }

                        }
                    }
                    
                    .opacity(1.0)


                Image("green-tea")
                    .resizable()
                    .frame(width: 220, height: 290)
                    .position(x: 10, y: 500-selecionadoGreen)
                    .animation(.easeInOut(duration: 0.5))
                    .onTapGesture {
                        if !falando{
                            if preEscolhaChaGreen == 1.0{
                                selecionadoWhite = 0
                                selecionadoGreen = 50
                                selecionadoHerbal = 0
                                preEscolhaChaGreen = 0.7
                                preEscolhaChaHerbal = 1.0
                                preEscolhaChaWhite = 1.0
                                falasPos = 5
                                print(preEscolhaChaHerbal)
                                print(preEscolhaChaGreen)
                                print(preEscolhaChaWhite)
                            }
                            else {
                                cha_escolhido = "green-tea"
                                status = .aguaNoFogo
                                falando = false
                                falasPos = 7
                            }
                            
                        }
                        
                    }
                    .opacity(1.0)

                Image("herbal-tea")
                    .resizable()
                    .frame(width: 220, height: 290)
                    .position(x: 10, y: 500-selecionadoHerbal)
                    .animation(.easeInOut(duration: 0.5))
                    .onTapGesture {
                        if !falando{
                            if preEscolhaChaHerbal == 1.0{
                                selecionadoWhite = 0
                                selecionadoGreen = 0
                                selecionadoHerbal = 50
                                preEscolhaChaHerbal = 0.7
                                preEscolhaChaGreen = 1.0
                                preEscolhaChaWhite = 1.0
                                falasPos = 6
                                print(preEscolhaChaHerbal)
                                print(preEscolhaChaGreen)
                                print(preEscolhaChaWhite)
                                
                            }
                            else {
                                cha_escolhido = "herbal-tea"
                                status = .aguaNoFogo
                                falando = false
                                falasPos = 7
                            }
                        }
                    }
                    .opacity(1.0)
                


                
                
                
                
            }
            if status == .selecionarTeapot{
                var nameFala = "fala"+String(falasPos)
                var escolhaChaFalaPos: Int {
                    if cha_escolhido == "white-tea" {
                        return 8
                    } else if cha_escolhido == "green-tea" {
                        return 9
                    } else if cha_escolhido == "herbal-tea" {
                        return 10
                    }
                    return 8
                }
                GeometryReader { geo in
                    Image(nameFala)
                        .resizable()
                        .frame(width: 1100, height: 300)
                        .position(x: geo.size.width*1.5, y: geo.size.height/6)
                        .opacity(mostrando)
                        .onTapGesture {
                            if falasPos >= 13{
                                falasPos += 1
                                if falasPos >= 14 {
                                    falasPos = 14
                                    falando = false
                                    mostrarWarning0 = 1.0

                                }
                            }
                            
                        }
                        .onAppear(){
                            mostrarWarning0 = 0.0
                            falando = true
                            falasPos = 13
                        }
                }
                GeometryReader { geo in
                    Image("teapot-small")

                        .position(x: (geo.size.width/1.4), y: (geo.size.height)*0.58)
                        .onTapGesture {
                            if !falando {
                                mostrandoOpisca = false
                                status = .teaPouring

                            }
                        }
                        .scaleEffect(isBlinkingTeapot ? 0.9 : 1.0)
                        .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true))
                        .onAppear(){
                                withAnimation {
                                    isBlinkingTeapot.toggle()
                                }
                            
                            
                            
                        }
                }
                GeometryReader { geo in
                    Image("warning0")
                        .resizable()
                        .frame(width: 154.5, height: 85)
                        .position(x: -(geo.size.width*0.7), y: (geo.size.height)*0.55)
                        .opacity(mostrarWarning0)
                        .animation(.easeInOut(duration: 0.5))

                }
                
            }
            if status == .teaPouring {
                var nameFala = "fala"+String(falasPos)
                var escolhaChaFalaPos: Int {
                    if cha_escolhido == "white-tea" {
                        return 8
                    } else if cha_escolhido == "green-tea" {
                        return 9
                    } else if cha_escolhido == "herbal-tea" {
                        return 10
                    }
                    return 8
                }
                
                GeometryReader { geo in
                    Image(nameFala)
                        .resizable()
                        .frame(width: 1100, height: 300)
                        .position(x: geo.size.width*2, y: geo.size.height/6)
                        .opacity(mostrando)
                        .onTapGesture {
                            if falasPos >= 16{
                                falando = true
                                falasPos += 1
                                warning = "warning3"
                                if falasPos >= 17 {
                                    falando = false
                                    falasPos = 17
                                    warning = "warning3"
                                    mostrandoOpisca = true
                                    withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                                        isBlinkingTeapot.toggle()
                                    }
                                    print(isBlinkingTeapot)
                                    print(mostrandoOpisca)
                                    print(blinkCupTeaPouring)
                                    

                                }
                            }
                            
                        }
                        .onAppear(){
                            falando = true
                            falasPos = 15
                        }
                        .zIndex(15)
                }
                
                GeometryReader { geo in
                    Image(warning)
                        .resizable()
                        .frame(width: 154.5, height: 85)
                        .position(x: (geo.size.width)*0.1, y: (geo.size.height)*0.8)
                        .opacity(1.0)
                        .onAppear(){
                            withAnimation(.easeInOut(duration: 0.5)){}
                        }
                }
                
                Image(imageCup)
                    .resizable()

                    .onAppear(){
                        
                        if mostrandoOpisca {
                                }
                        if cha_escolhido == "green-tea"
                        {
                            self.imageCup = "cupGreen0"
                        }
                        else if cha_escolhido == "white-tea"
                        {
                            self.imageCup = "cupBranco0"
                        }
                        else if cha_escolhido == "herbal-tea"
                        {
                            self.imageCup = "cupErva0"
                        }
                    }
                    // THIS ANIMATION IS SO CUTE OMG
                    .scaleEffect(isBlinkingTeapot ? 0.9 : 1.0)
                    .frame(width: 300, height: 200)
                    .position(x: 00, y: 680)
                    .onTapGesture {
                        print("CLICOU")
                        if !falando {
                            if timeElapsed >= 40.0
                            {
                                
                                timeElapsed = 0.0
                                status = .blow
                            }
                        }
                        
                        
                    }
                    .zIndex(zPositionCup)
                
                    
                
                Image(imageTeapot)
                    .resizable()
                    .frame(width: 700, height: 520)
                    .rotationEffect(.degrees(rotation))
                    .position(x:-80, y: 461)
                    .disabled(status.objectsTeaPouring)
                    .opacity(status.objectsTeaPouring ? 1 : 0)
                    .zIndex(11)
                    .onAppear {
                        
                        if let audioFileURL = Bundle.main.url(forResource: "tea", withExtension: "mp3") {
                            do {
                                audioSounds = try AVAudioPlayer(contentsOf: audioFileURL)
                                audioSounds?.prepareToPlay()

                                
                            } catch {
                                print("Não foi possível reproduzir a música.")
                            }
                        } else {
                            print("O arquivo de áudio não foi encontrado.")
                        }
                        
                        
                        
                        
                        
                        
                        
                        motionManager.startDeviceMotionUpdates(to: motionQueue) { (data, error) in
                            guard let data = data else {
                                print("Error: \(error!)")
                                return
                            }
                            
                            let xRotation = data.attitude.roll * 180 / Double.pi
                            let yRotation = data.attitude.pitch * 180 / Double.pi
                            let zRotation = data.attitude.yaw * 180 / Double.pi
                            
                            
                            if yRotation < -25 && status == .teaPouring && !jaEncheu{
                                if tocandoTea == 0{
                                    audioSounds?.volume = 1
                                    audioSounds?.prepareToPlay()
                                    audioSounds?.play()
                                    tocandoTea = 1
                                }
                                imageTeapot = "teapot_pouringTest"
                                
                                timeElapsed += 0.1
                                print(timeElapsed)
                                if timeElapsed >= 40.0 {
                                    if cha_escolhido == "green-tea"
                                    {
                                        self.imageCup = "cupGreen"
                                    }
                                    else if cha_escolhido == "white-tea"
                                    {
                                        self.imageCup = "cupBranco"
                                    }
                                    else if cha_escolhido == "herbal-tea"
                                    {
                                        self.imageCup = "cupErva"
                                    }
                                    if falando{
                                        falasPos = 16
                                    }
                                    jaEncheu = true
                                    zPositionCup = 12
                                    
                                }
                            } else {
                                audioSounds?.stop()
                                audioSounds?.currentTime = 0.0
                                tocandoTea = 0
                                imageTeapot = "teapot"
                            }
                            DispatchQueue.main.async {
                                if imageTeapot != "teapot_pouringTest"
                                {
                                    rotation = yRotation
                                }
                               
                            }
                        }
                    }
            }
                
                
                
            }
        .onAppear{
            if status == .menuInicial
            {
                background =  "menu-inicial"
            }
            else if status == .menuFinal && cha_escolhido == "green-tea"
            {
                background = "menu-final-green"
            }
            else if status == .menuFinal && cha_escolhido == "white-tea"
            {
                background = "menu-final-white"
            }

            else if status == .menuFinal && cha_escolhido == "herbal-tea"
            {
                background = "menu-final-herbal"
            }

            else {
                background = "bg-kitchen"
            }
            gameManager.blowDetector.startDetecting()
        }
        .background(
            Image(background)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: status.blurValue)
                    .onAppear(){
                        
                        if let audioFileURL = Bundle.main.url(forResource: "lofi", withExtension: "mp3") {
                            do {
                                audioLofi = try AVAudioPlayer(contentsOf: audioFileURL)
                                audioLofi?.numberOfLoops = 10
                                audioLofi?.prepareToPlay()

                                
                            } catch {
                                print("Não foi possível reproduzir a música.")
                            }
                        } else {
                            print("O arquivo de áudio não foi encontrado.")
                        }
                        audioLofi?.volume = 0.06
                        audioLofi?.prepareToPlay()
                        audioLofi?.play()
                    }
            )
            
            .onTapGesture {
                if status == .menuFinal{
                    rotation = 0.0
                    rotationCup = 0.0
                    imageCup = "cupGreen0"
                    
                    imageTeapot = "teapot"
                    timeElapsed = 0.0
                    timeFogao = 0.0
                    tocandoTea = 0
                    cha_escolhido = "green-tea"
                    
                    
                    isBlinkingTeapot = false
                    isDragging = CGSize.zero
                    
                    teapotPosX = 600.0
                    teapotPosY = 480.0
                    fogaoPosX = 430.0
                    fogaoPosY = 500.0
                    
                    collision = false

                    opacityFogo = 0.0
                    timeElapsedBeberCha = 0.0
                    jabebeu = 0
                    
                    falasPos = 1
                    
                    timeElapsedBlow = 0.0
                    preEscolhaChaWhite = 1.0
                    preEscolhaChaGreen = 1.0
                    preEscolhaChaHerbal = 1.0
                    falando = true
                    mostrando = 1.0
                    sips = 0
                    warning = "warning1"
                    jaEncheu = false
                    zPositionCup = 10
                    selecionadoWhite = 0
                    selecionadoGreen = 0
                    selecionadoHerbal = 0
                    mostrarWarning4 = 0.0
                    mostrarWarning0 = 0.0
                    mostrarWarning2 = 0.0
                    blinkCupTeaPouring = 1.0

                    mostrandoOpisca = false
                    status = .menuInicial

                }
            }
            
        }
    func checkCollision() {
        if teapotPosX  > 450 && teapotPosY > 400{
            collision = true
            status = .aguaNoFogoComSucesso
            timeFogao = 0.0
            teapotPosX = 400.0
            teapotPosY = 480.0
            print("COLIDIU")
        } else {
            collision = false
            print("NAO TA COLIDINDO PARSA")


        }
    }

        
    }


        
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
            
        }
    }

