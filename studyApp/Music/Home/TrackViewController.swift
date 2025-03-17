//
//  ViewController.swift
//  musicProject
//
//  Created by NaGyeom Lee on 3/2/25.
//

import UIKit

class TrackViewController: UIViewController {
    
    let trackManager : TrackManager = TrackManager()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension TrackViewController : UICollectionViewDataSource {
    // 각 셀을 어떻게 표시할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = trackManager.track(at: indexPath.item)
        cell.updateUI(item : item)
        return cell
    }
    
    // 데이터를 몇개 표시할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }
    
    // headerView 어떻게 표시할까?
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item = trackManager.todaysTrack else {
                return UICollectionReusableView()
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            
            header.update(with: item)
            header.tapHandler = { item -> Void in
                // 곡 클릭시 플레이 뷰 띄우기
                let playBoard = UIStoryboard.init(name : "Play", bundle : nil)
                guard let playVC = playBoard.instantiateViewController(identifier: "PlayViewController") as? PlayViewController else {return}
                
                let item = self.trackManager.tracks[indexPath.item]
                playVC.simplePlayer.replaceCurrentItem(with: item)

                self.present(playVC, animated: true, completion: nil)
            }
            
            // 헤더 구성하기
            return header
        default :
            return UICollectionReusableView()
        }
    }
}

extension TrackViewController : UICollectionViewDelegate {
    // 클릭했을때 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 곡 클릭시 플레이 뷰 띄우기
        let playBoard = UIStoryboard.init(name : "Play", bundle : nil)
        guard let playVC = playBoard.instantiateViewController(identifier: "PlayViewController") as? PlayViewController else {return}
        
        let item = trackManager.tracks[indexPath.item]
        playVC.simplePlayer.replaceCurrentItem(with: item)
        
        present(playVC, animated: true, completion: nil)
    }
}

extension TrackViewController : UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 20
        let margin: CGFloat = 20
        let width = (collectionView.bounds.width - itemSpacing - margin * 2) / 2
        let height = width + 60
        print("width, height ---> \(width) \(height)")
        return CGSize(width: width, height: height)
    }

}

