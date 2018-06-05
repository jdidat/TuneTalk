//
//  SimiarArtistsViewController.swift
//  TuneTalk
//
//  Created by Jackson Didat on 5/12/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import AlamofireImage

class SimilarArtistsViewController: UIViewController {
    
    var name = ""
    var artist: [[String : Any]] = []
    let APIkey = "e1523431ee9c18604fb535cf31cdbcc8"
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistBio: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchArtist()
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
                self.artistName.text = self.name
                self.artistBio.text = bio
                self.artistImage.af_setImage(withURL: image)
            }
        }
        task.resume()
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
