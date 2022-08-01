//
//  WelcomeVideoCardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 21/01/22.
//

import SwiftUI
import AVKit

struct WelcomeVideoCardView: View {
    
//    @Binding var welcomeTitle: String
    @Binding var player: AVPlayer
    @Binding var shouldPlay: Bool
    @State var playedOnce = false
    var onVideoEnd: ()->Void = {}

    var body: some View {
        VStack {
            if player.currentItem != nil {
                VStack {
                   // Spacer()
                    HStack {
                        Text(StaticLabel.get("txtWelecomeToAcademy"))
                            .foregroundColor(.white)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .vvLarge))
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 16)
                    
                    CustomVideoPlayer(player: $player, shouldPlay: $shouldPlay, playedOnce: $playedOnce, height: 220) {
                        onVideoEnd()
                    }
                }
                .padding(.horizontal, 16)
                .background(Color.darkPurple)
            }
        }
    }
}

struct CustomVideoPlayer: View {
    @Binding var player: AVPlayer
    @Binding var shouldPlay: Bool
    @Binding var playedOnce: Bool
    var height: CGFloat
    var onVideoEnd: ()->Void = {}
    
    var body: some View {
        ZStack {
            CustomVideoPlayerController(player: $player, shouldPlay: $shouldPlay, playedOnce: $playedOnce) {
                onVideoEnd()
            }
            .onDisappear {
                player.pause()
                shouldPlay = false
            }
            
            if !playedOnce {
                ZStack {
                    Image("DefaultImage", bundle: AppConstants.bundle)
                        .resizable()
                        .frame(height: height)
                    
                    Color.black.opacity(0.2)
                    
                    Button(action: {
                        
                        let welcomeVideoPlayTouch = GenericEventInfo(name: "Academy: Welcome Video: Touch: Play")
                        RootViewModel.shared.creatorAction?.action(.analytics(event: welcomeVideoPlayTouch))
                        
                        shouldPlay.toggle()
                        playedOnce = true
                    }) {
                        Image("PlayPauseIcon", bundle: AppConstants.bundle)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                }
            }
        }
        .customRoundedRectangle()
        .aspectRatio(16/9, contentMode: .fit)
        .frame(height: height)
    }
}


struct CustomVideoPlayerController: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    @Binding var shouldPlay: Bool
    @Binding var playedOnce: Bool
    var onVideoEnd: ()->Void

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.player = player
        playerController.showsPlaybackControls = false
        if shouldPlay {
            playerController.player?.play()
        } else {
            playerController.player?.pause()
        }
        
        if !playedOnce {
            playerController.showsPlaybackControls = false
        } else {
            playerController.showsPlaybackControls = true
        }
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: player.currentItem!.duration)], queue: .main) {
            onVideoEnd()
        }
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
