//
//  DetailsViewController.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var authorBack: UIView!
    @IBOutlet weak var author: UILabel!
        @IBOutlet weak var descrip: UITextView!
    var detailsViewModel = DetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupView()
    }

    @IBAction func addToFav(_ sender: Any) {
    }
    
    private func setupUI(){
        guard let url = detailsViewModel.newsDetails?.urlToImage else{return}
            self.imgNews.kf.setImage(with: URL(string: url),placeholder: UIImage(named:"Nophoto"))
        titleNews.text = detailsViewModel.newsDetails?.title
        print(detailsViewModel.newsDetails?.title ?? "")
        author.text = detailsViewModel.newsDetails?.author ?? "Reliable Source"
        print( detailsViewModel.newsDetails?.author ?? "")
        descrip.text = detailsViewModel.newsDetails?.description
    }
    
    private func setupView(){
        favBtn.tintColor = UIColor.color1
        vBack.layer.cornerRadius = 15
        imgNews.layer.cornerRadius = 15
        authorBack.layer.cornerRadius = 20
        authorBack.layer.masksToBounds = true
    }

}
