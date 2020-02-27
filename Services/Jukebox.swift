import AVFoundation
import StreamingKit

class Jukebox {
    
    static let shared = Jukebox()

    var player1, player2: STKAudioPlayer?
    var options = STKAudioPlayerOptions()
    var transition: Bool = false
    var timer: Timer?
    var id: Int = 0
    
    func url(_ id: Int) -> String {
        return "http:/domain.com/\(id)"
    }
    
    init() {
        if #available(iOS 10.0, *) {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options:.mixWithOthers)
        } else {
            try? AVAudioSession.sharedInstance().setMode(AVAudioSession.Mode.default)
        }
        
        try? AVAudioSession.sharedInstance().setActive(true)
        initPlayer1()
    }
    
    func initPlayer1() {
        guard player1 == nil else { return }
        player1?.volume = 1.0
        options.enableVolumeMixer = true
        player1 = STKAudioPlayer(options: options)
    }
    
    func initPlayer2() {
        guard player2 == nil else { return }
        player2?.volume = 1.0
        options.enableVolumeMixer = true
        player2 = STKAudioPlayer(options: options)
    }
    
    func startStream(id: Int) {
        self.id = id
        initPlayer1()
        player1?.play(url(id))
    }
    
    func switchStream(to id: Int) {
        guard !transition else { return }
        transition = true
        self.id = id
        if player1 != nil {
            initPlayer2()
            player2?.volume = 0.0
            player2?.play(url(id))
            if player1 != nil && player2 != nil {
                fadeIn(p1: player1!, p2: player2!)
            }
        } else {
            initPlayer1()
            player1?.volume = 0.0
            player1?.play(url(id))
            if player1 != nil && player2 != nil {
                fadeIn(p1: player2!, p2: player1!)
            }
        }
    }
    
    func stopStream() {
        player1?.stop()
        player1 = nil
        player2?.stop()
        player2 = nil
        transition = false
        self.timer = nil
    }
    
    func fadeIn(p1: STKAudioPlayer, p2: STKAudioPlayer) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: (p1, p2), repeats: true)
        }
    }
    
    @objc func timerAction(timer: Timer) {
        let (p1,p2):(STKAudioPlayer,STKAudioPlayer) = timer.userInfo as! (STKAudioPlayer, STKAudioPlayer)
        p1.volume = round(10.0 * (p1.volume - 0.1)) / 10.0
        p2.volume = round(10.0 * (p2.volume + 0.1)) / 10.0
        if p2.volume == 1.0 {
            timer.invalidate()
            self.stopPlayer(p: p1)
        }
    }
    
    func stopPlayer(p: STKAudioPlayer) {
        if p == player1 {
            player1?.stop()
            player1 = nil
        } else {
            player2?.stop()
            player2 = nil
        }
        transition = false
        self.timer = nil
    }
}
