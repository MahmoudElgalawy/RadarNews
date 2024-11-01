//
//  CollectionViewCell.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        vBack.layer.cornerRadius = 10
        imgNews.layer.cornerRadius = 10
        titleBack.layer.cornerRadius = 10
        titleBack.layer.masksToBounds = true
    }
    static func nib()->UINib{
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    func configureCell(news:News){
        guard let imgUrl = news.urlToImage else{
            return imgNews.image =  UIImage(named:"Nophoto")}
        DispatchQueue.main.async {
            self.imgNews.kf.setImage(with: URL(string: imgUrl))
        }
        title.text = news.title
        author.text = news.author ?? "Reliable Source"
        desc.text = news.description
    }
}
