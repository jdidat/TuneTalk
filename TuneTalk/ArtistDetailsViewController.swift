//
//  SimiarArtistsViewController.swift
//  TuneTalk
//
//  Created by Jackson Didat on 5/12/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import AlamofireImage

class ArtistDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var songCollectionView: UICollectionView!
    @IBOutlet weak var similarArtistsCollectionView: UICollectionView!
    
    var albums: [[String : Any]] = []
    var songs: [[String : Any]] = []
    var similarArtists: [[String : Any]] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0;
        if collectionView == self.albumCollectionView {
            count = albums.count
        }
        else if collectionView == self.songCollectionView {
            count = songs.count
        }
        else {
            count = similarArtists.count
        }
        return count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.albumCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
            let album = albums[indexPath.item]
            let albumImages = album["image"] as! [[String : Any]]
            let albumImage = albumImages[2]["#text"] as! String
            print(albumImage)
            if let albumURL = URL(string: albumImage) {
                cell.albumCover.af_setImage(withURL: albumURL)
            }
            return cell
        }
        else if collectionView == self.songCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCollectionViewCell
            let song = songs[indexPath.item]
            let songName = song["name"] as! String
            let songImages = song["image"] as! [[String : Any]]
            let songImage = songImages[2]["#text"] as! String
            cell.songTitle.text = songName
            if let songURL = URL(string: songImage) {
                cell.songCover.af_setImage(withURL: songURL)
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarArtistCell", for: indexPath) as! SimiarArtistCollectionViewCell
            let artist = similarArtists[indexPath.item]
            let artistImages = artist["image"]
            let artistImage = artistImages[2]["#text"] as! String
            
        }
    }
    
    var name = ""
    var artist: [[String : Any]] = []
    let APIkey = "e1523431ee9c18604fb535cf31cdbcc8"
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistBio: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCollectionView.dataSource = self
        artistBio!.layer.borderWidth = 1
        artistBio!.layer.borderColor = UIColor.black.cgColor
        searchArtist()
        getArtistsAlbums(success: { (data) in
            self.albums = data
        }, failure: { (error) in })
        getArtistsSongs(success: { (data) in
            self.songs = data
        }, failure: { (error) in })
        print(albums)
        print(songs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchArtist() {
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=" + self.name +  "&api_key=e1523431ee9c18604fb535cf31cdbcc8&format=json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let data = dataDictionary["artist"] as! [String : Any]
                let summary = data["bio"] as! [String: Any]
                let bio = summary["content"] as! String
                let images = data["image"] as! [[String : Any]]
                let imageURL = images[3]["#text"] as! String
                let image = URL(string: imageURL)!
                self.artistName.text = self.name.replacingOccurrences(of: "+", with: " ")
                self.artistBio.text = bio
                self.artistImage.af_setImage(withURL: image)
            }
        }
        task.resume()
    }
    
    @objc func getArtistsAlbums(success: @escaping ([[String: Any]]) -> (), failure: @escaping (Error) -> ()) {
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=" + self.name +  "&api_key=e1523431ee9c18604fb535cf31cdbcc8&format=json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let data = dataDictionary["topalbums"] as! [String : Any]
                let albums = data["album"] as! [[String : Any]]
                success(albums)
                self.albumCollectionView.reloadData()
            }
        }
        task.resume()
    }
    
    @objc func getArtistsSongs(success: @escaping ([[String : Any]]) -> (), failure: @escaping (Error) -> ()) {
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=" + self.name + "&api_key=e1523431ee9c18604fb535cf31cdbcc8&format=json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let data = dataDictionary["toptracks"] as! [String : Any]
                let songs = data["track"] as! [[String : Any]]
                print(songs)
                success(songs)
                self.songCollectionView.reloadData()
            }
        }
        task.resume()
    }
    
    @objc func getSimilarArtists(success: @escaping ([[String : Any]]) -> (), failure: @escaping (Error) -> ()) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
