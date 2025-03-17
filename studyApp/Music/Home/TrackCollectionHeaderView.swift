//
//  TrackCollectionHeaderViewCollectionReusableView.swift
//  musicProject
//
//  Created by NaGyeom Lee on 3/3/25.
//

import UIKit
import AVFoundation

class TrackCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item : AVPlayerItem?
    var tapHandler : ((AVPlayerItem) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    func update(with item : AVPlayerItem) {
        // 헤더뷰 업데이트하기
        self.item = item
        guard let track = item.convertToTrack() else {return}
        
        self.thumbnailImageView.image = track.artwork
        self.descriptionLabel.text = "Today's pick is \(track.artist) - \(track.albumName), Let's Listen!"
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        // Tab 했을 때 처리
        guard let todayItem = item else {return}
        tapHandler?(todayItem)
    }
}
