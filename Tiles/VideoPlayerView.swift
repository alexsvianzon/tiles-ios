//
//  VideoPlayerView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 8/18/26.
//

import SwiftUI
import AVKit

struct VideoPlayer: View {
    private var player: AVPlayer
    private var delay: TimeInterval

    init(url: URL, delaySeconds: TimeInterval = 1.0) {
        self.player = AVPlayer(url: url)
        self.delay = delaySeconds
    }

    var body: some View {
        VideoPlayerContainer(player: player)
            .onAppear {
                addLoopNotification()
                player.play()
            }
            .onDisappear {
                removeLoopNotification()
                player.pause()
            }
    }

    private func addLoopNotification() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                player.seek(to: .zero)
                player.play()
            }
        }
    }

    private func removeLoopNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
}

struct VideoPlayerContainer: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        context.coordinator.playerLayer = playerLayer
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.playerLayer?.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var playerLayer: AVPlayerLayer?
    }
}
