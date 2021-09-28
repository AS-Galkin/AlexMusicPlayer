//
//  TrackDetailView.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 27.09.2021.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var dragDownButton: UIButton!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var summaryTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var previousTrackButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    private func playTrack(trackPreviewUrl: String?) {
        guard let url = URL(string: trackPreviewUrl ?? "") else { return }
        
        let playItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playItem)
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    }
    
    func setDisplayedData(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        
        guard let url600 = URL(string: viewModel.trackImageUrl?.replacingOccurrences(of: "100x100", with: "600x600") ?? "") else { return }
        monitorPlayingStartTime()
        trackImageView.sd_setImage(with: url600, completed: nil)
        playTrack(trackPreviewUrl: viewModel.trackPreviewUrl)
    }
    
    private func monitorPlayingStartTime() {
        let time: CMTime = CMTimeMake(value: 1, timescale: 3)
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: .main) {[weak self] in
            self?.playerStartPlaying()
        }
    }
    
    private func playerStartPlaying() {
        UIImageView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            self?.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func playerStopPlaying() {
        UIImageView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            self?.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
    
    @IBAction func dragDownButtonHandler(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func currentTimeSliderHandler(_ sender: UISlider) {
    }
    
    @IBAction func prevTrackButtonHandler(_ sender: UIButton) {
    }
    
    
    @IBAction func playPauseButtonHandler(_ sender: UIButton) {
        switch player.timeControlStatus {
        case .paused:
            player.play()
            playerStartPlaying()
            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            break
        case .waitingToPlayAtSpecifiedRate:
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            break
        case .playing:
            player.pause()
            playerStopPlaying()
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            break
        @unknown default:
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            break
        }
    }
    
    @IBAction func nextTrackButtonHandler(_ sender: UIButton) {
    }
    
    @IBAction func volumeSliderHandler(_ sender: UISlider) {
    }
}
