import AVFoundation

final class BlowDetector {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var detectionThreshold: Float
    
    init(detectionThreshold: Float) {
        self.detectionThreshold = detectionThreshold
    }
    
    func startDetecting() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
//            try recordingSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
            
            if recordingSession.recordPermission == .granted {
                startRecording()
                print("Mic permission granted")
                return
            } else {
                print("Request permission")
            }
            
            recordingSession.requestRecordPermission() { [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self?.startRecording()
                    } else {
                        print("failed to record!")
                    }
                }
            }
        } catch {
            print("error recording session")
            print(error)
        }
    }
    
    private func startRecording() {
        let audioFilename = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording.caf")
        
        let settings = [
            AVFormatIDKey: kAudioFormatAppleIMA4,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 12800,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
        } catch {
            stop()
        }
    }
    
    func stop() {
        if audioRecorder == nil {
            return
        }
        
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func detectedBlow() -> Bool {
        if audioRecorder == nil {
            return false
        }
        
        self.audioRecorder.updateMeters()
        
        let volume = audioRecorder.averagePower(forChannel: 0)
        print(volume)
        if volume > detectionThreshold {
            return true
        }
        
        return false
    }
}
