//
//  DetailsViewController.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var authorBack: UIView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var descrip: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vBack.layer.cornerRadius = 10
        imgNews.layer.cornerRadius = 10
        authorBack.layer.cornerRadius = 10
        authorBack.layer.masksToBounds = true
    }

    @IBAction func addToFav(_ sender: Any) {
    }
    
    

}
