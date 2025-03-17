//
//  TrackManager.swift
//  musicProject
//
//  Created by NaGyeom Lee on 3/2/25.
//

import UIKit
import AVFoundation

class TrackManager {
    // Track 프로퍼티 정의하기
    var tracks : [AVPlayerItem] = []
    var albums : [Album] = []
    var todaysTrack : AVPlayerItem?
    
    // 생성자 정의하기
    init() {
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbum(tracks: tracks)
        self.todaysTrack = self.tracks.randomElement()
    }
    
    // Track 로드하기
    func loadTracks() -> [AVPlayerItem] {
        // 파일들을 읽어서 AVplayersItem 만들기
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory : nil) ?? []
        let items = urls.map{
            url in return AVPlayerItem(url:url)
        }
        return items
    }
    
    // Index 에 맞는 Track 로드하기
    func track(at index : Int) -> Track? {
        let playerItem = tracks[index]
        return playerItem.convertToTrack()
    }
    
    // Album 로딩 메서드 구현
    func loadAlbum(tracks : [AVPlayerItem]) -> [Album] {
        let trackList : [Track] = tracks.compactMap { $0.convertToTrack() }
        let albumDics = Dictionary(grouping: trackList, by: {(track) in track.albumName})
        var albums : [Album] = []
        for (key, value) in albumDics {
            let title = key
            let traks = value
            let album = Album(title: title, tracks: traks)
            albums.append(album)
        }
        return albums
    }
    
    // Todays Track 랜덤으로 로드하기
    func randomTrack() {
       
    }
}
