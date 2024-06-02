import AVFoundation
import MediaPlayer

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.testing.qawl/audio_session"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let audioSessionChannel = FlutterMethodChannel(name: channelName,
                                                   binaryMessenger: controller.binaryMessenger)

    audioSessionChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: FlutterResult) in
      switch call.method {
      case "configureAudioSession":
        self?.configureAudioSession(result: result)
      case "updateNowPlayingInfo":
        if let args = call.arguments as? [String: Any] {
          self?.updateNowPlayingInfo(args)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureAudioSession(result: FlutterResult) {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playback, options: [.allowBluetooth, .allowAirPlay])
      try session.setActive(true)
      result(nil)
    } catch {
      result(FlutterError(code: "AudioSessionError",
                          message: "Failed to configure audio session",
                          details: error.localizedDescription))
    }
  }

  private func updateNowPlayingInfo(_ info: [String: Any]) {
    var nowPlayingInfo = [String: Any]()

    if let title = info["title"] as? String {
      nowPlayingInfo[MPMediaItemPropertyTitle] = title
    }
    if let artist = info["artist"] as? String {
      nowPlayingInfo[MPMediaItemPropertyArtist] = artist
    }
    if let artUri = info["artUri"] as? String, let url = URL(string: artUri) {
      let data = try? Data(contentsOf: url)
      if let data = data, let image = UIImage(data: data) {
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
          return image
        }
      }
    }
    if let duration = info["duration"] as? Int {
      nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
    }
    if let position = info["position"] as? Int {
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = position
    }

    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
}
