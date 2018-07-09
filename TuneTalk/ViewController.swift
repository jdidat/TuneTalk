//
//  ViewController.swift
//  TuneTalk
//
//  Created by Jackson Didat on 5/11/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var similarArtists = [[String : Any]]()
    var name = ""
    
    @IBOutlet weak var artist: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapGet(_ sender: Any) {
        let artistSearch = artist.text!
        let search = artistSearch.replacingOccurrences(of: " ", with: "+")
        self.name = search
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let similarArtistsViewController = segue.destination as! ArtistDetailsViewController
        similarArtistsViewController.name = self.name
    }
    
}

