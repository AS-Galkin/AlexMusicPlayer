//
//  TrackCell.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 23.09.2021.
//

import UIKit
import SDWebImage

protocol CellViewModelProtocol {
    var trackName: String? { get }
    var collectionName: String? { get }
    var artistName: String? { get }
    var trackImageUrl: String? { get }
}

protocol SaveDataProtocol {
    func saveTrack(for object: SearchViewModel.Cell)
    static func loadTracks(closure: @escaping ([SearchViewModel.Cell]?) -> Void)
    static func deleteTrack(at offset: IndexSet)
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var saveTrackButton: UIButton!
    var interactorDelegate: SearchBusinessLogic?
    private var cellData: SearchViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setViewData(viewModel: SearchViewModel.Cell) {
        cellData = viewModel
        
        SearchInteractor.loadTracks { tracks in
            if let tracks = tracks {
                if tracks.contains(where: { track in
                    return viewModel.artistName == track.artistName && viewModel.trackName == track.trackName
                }) {
                    self.saveTrackButton.isHidden = true
                } else {
                    self.saveTrackButton.isHidden = false
                }
            }
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        if let url = URL(string: viewModel.trackImageUrl ?? "") {
            trackImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    //MARK: - IBActions
    @IBAction func saveTrackHandler(_ sender: UIButton) {
        saveTrackButton.isHidden = true
        
        guard let cellData = self.cellData else { return }
        
        if let interactor = interactorDelegate as? SearchInteractor {
            interactor.saveTrack(for: cellData)
        }
    }
    

}
