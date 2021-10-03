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
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var saveTrackButton: UIButton!
    weak var interactorDelegate: SearchInteractor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBAction func saveTrackHandler(_ sender: UIButton) {
        
    }
    
    func setViewData(viewModel: CellViewModelProtocol) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        if let url = URL(string: viewModel.trackImageUrl ?? "") {
            trackImage.sd_setImage(with: url, completed: nil)
        }
    }
}
