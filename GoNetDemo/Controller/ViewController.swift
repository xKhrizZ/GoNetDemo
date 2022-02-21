//
//  ViewController.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 16/02/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgViewLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5) {
            self.imgViewLogo.alpha = 1.0
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "HomeSegue", sender: nil)
        }
        
        
    }


}

