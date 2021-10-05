//
//  TrackDetailView.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 27.09.2021.
//

import UIKit
import SDWebImage
import AVKit

//MARK: - TrackMoveingDelegate

protocol TrackMovingDelegate: Any {
    func move(seek: Int) -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    //MARK: - Variables
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
    @IBOutlet weak var miniNextTrackButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniPlayButton: UIButton!
    @IBOutlet weak var miniImageView: UIImageView!
    @IBOutlet weak var trackStackView: UIStackView!
    @IBOutlet weak var miniTrackLabel: UILabel!
    private var currentCellViewModel: SearchViewModel.Cell?
    var delegate: TrackMovingDelegate?
    var tabBarDelegate: MainTabBarDelegate?
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    //MARK: - Other functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        miniTrackView.alpha = 0
        
        setupGestureMiniTrackView()
    }
    
    private func playTrack(trackPreviewUrl: String?) {
        guard let url = URL(string: trackPreviewUrl ?? "") else { return }
        
        let playItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playItem)
        player.play()
        setButtonsImage(buttons: [playPauseButton, miniPlayButton], image: #imageLiteral(resourceName: "pause"))
    }
    
    private func setButtonsImage(buttons: [UIButton], image: UIImage) {
        for button in buttons {
            button.setImage(image, for: .normal)
        }
    }
    
    //MARK: - Setup gestures
    
    private func setupGestureMiniTrackView() {
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(sender:))))
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapRecognizer)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissHandlePanRecognizer(sender:))))
    }
    
    @objc private func dismissHandlePanRecognizer(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self.superview)
            trackStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            break
        case .ended:
            let translation = sender.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
                self?.trackStackView.transform = .identity
                if translation.y > 50 {
                    self?.tabBarDelegate?.minimizeDetailTrackView()
                }
            }, completion: nil)
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handlePanRecognizer(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            handlePanBegin(gesture: sender)
            break
        case .changed:
            handlePanChanges(gesture: sender)
            break
        case .ended:
            handlePanEnded(gesture: sender)
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handleTapRecognizer() {
        tabBarDelegate?.maximazeDetailTrackView(viewModel: nil)
    }
    
    private func handlePanChanges(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let aplha = 1 + translation.y / 200

        miniTrackView.alpha = aplha < 0 ? 0 : aplha
        
        trackStackView.alpha = -translation.y / 200
 
    }
    
    private func handlePanBegin(gesture: UIPanGestureRecognizer) {
        
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {[weak self] in
            self?.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                self?.tabBarDelegate?.maximazeDetailTrackView(viewModel: nil)
            } else {
                self?.tabBarDelegate?.minimizeDetailTrackView()
            }
        }, completion: nil)
        

    }
    
    //MARK: - First setup playing
    func setDisplayedData(viewModel: SearchViewModel.Cell) {
        let edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        trackTitleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        
        miniTrackLabel.text = viewModel.trackName
        miniPlayButton.imageEdgeInsets = edge
        miniNextTrackButton.imageEdgeInsets = edge
        
        guard let url600 = URL(string: viewModel.trackImageUrl?.replacingOccurrences(of: "100x100", with: "600x600") ?? "") else { return }
        
        monitorPlayingStartTime()
        makeTimerForTimeLabel(timeInterval: CMTimeMake(value: 1, timescale: 1))
        trackImageView.sd_setImage(with: url600) { [weak self] image, _, _, _ in
            self?.miniImageView.image = image
        }
        playTrack(trackPreviewUrl: viewModel.trackPreviewUrl)
    }
    
    
    //MARK: - Working with time
    private func monitorPlayingStartTime() {
        let time: CMTime = CMTimeMake(value: 1, timescale: 3)
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: .main) {[weak self] in
            self?.playerStartPlaying()
        }
    }
    
    
    private func makeTimerForTimeLabel(timeInterval: CMTime) {
        player.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toString()
            self?.summaryTimeLabel.text = "-\(((self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)) - time).toString())"
            self?.updateCurrentTimeOnSlider(currentTime: self?.player.currentTime(), player: self?.player)
        }
    }
    
    private func updateCurrentTimeOnSlider(currentTime: CMTime?, player: AVPlayer?) {
        guard player != nil,
              currentTime != nil else {
            return
        }
        currentTimeSlider.value = Float(CMTimeGetSeconds(currentTime!) / CMTimeGetSeconds(player!.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))
    }
    
    //MARK: - Working with play/pause
    private func playerStartPlaying() {

        UIImageView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
            self?.trackImageView.transform = .identity
        } completion: { _ in
        }
    }
    
    private func playerStopPlaying() {
        UIImageView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
            self?.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
        }
    }
    
    
    //MARK: - IBActions
    @IBAction func dragDownButtonHandler(_ sender: UIButton) {
        self.tabBarDelegate?.minimizeDetailTrackView()
    }
    
    @IBAction func currentTimeSliderHandler(_ sender: UISlider) {
        let seekTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)) * Float64(sender.value)
        player.currentItem?.seek(to: CMTimeMakeWithSeconds(seekTime, preferredTimescale: 1), completionHandler: nil)

    }
    
    @IBAction func prevTrackButtonHandler(_ sender: UIButton) {
        guard let model = delegate?.move(seek: -1) else {
            return
        }
        self.setDisplayedData(viewModel: model)
    }
    
    
    @IBAction func playPauseButtonHandler(_ sender: UIButton) {
        switch player.timeControlStatus {
        case .paused:
            player.play()
            playerStartPlaying()
            setButtonsImage(buttons: [playPauseButton, miniPlayButton], image: #imageLiteral(resourceName: "pause"))
            break
        case .waitingToPlayAtSpecifiedRate:
            setButtonsImage(buttons: [playPauseButton, miniPlayButton], image: #imageLiteral(resourceName: "pause"))
            break
        case .playing:
            player.pause()
            playerStopPlaying()
            setButtonsImage(buttons: [playPauseButton, miniPlayButton], image: #imageLiteral(resourceName: "play"))
            break
        @unknown default:
            setButtonsImage(buttons: [playPauseButton, miniPlayButton], image: #imageLiteral(resourceName: "play"))
            break
        }
    }
    
    @IBAction func maximazeMiniTrackView(_ sender: UIButton) {
        self.tabBarDelegate?.maximazeDetailTrackView(viewModel: nil)
    }
    
    @IBAction func nextTrackButtonHandler(_ sender: UIButton) {
        guard let model = delegate?.move(seek: 1) else {
            return
        }
        self.setDisplayedData(viewModel: model)
    }
    
    @IBAction func volumeSliderHandler(_ sender: UISlider) {
        player.volume = sender.value
    }
}
