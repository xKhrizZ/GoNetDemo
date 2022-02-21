//
//  DetailViewController.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 19/02/22.
//

import UIKit
import iOSBusinessDomain

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: CustomImageViewModel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var movieDetail: Results?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = movieDetail?.poster_path {
            posterImageView.loadImage(urlStr: "\(BusinessDomainManager.imagePath)\(img ?? "")")
        }
        
        self.titleLabel.text = movieDetail?.title
        self.overViewLabel.text = movieDetail?.overview
    }
}
