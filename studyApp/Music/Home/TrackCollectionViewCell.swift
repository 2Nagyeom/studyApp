//
//  TrackCollectionViewCell.swift
//  musicProject
//
//  Created by NaGyeom Lee on 3/2/25.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var TrackThumbnail: UIImageView!
    @IBOutlet weak var TrackTItle: UILabel!
    @IBOutlet weak var TrackArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TrackThumbnail.layer.cornerRadius = 4
        TrackArtist.textColor = UIColor.systemGray2
    }
    
    func updateUI(item : Track?) {
        // 곡 정보 표시하기
        guard let track = item else { return }
        TrackThumbnail.image = track.artwork
        TrackTItle.text = track.title
        TrackArtist.text = track.artist
    }
}
