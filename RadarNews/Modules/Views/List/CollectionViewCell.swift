//
//  CollectionViewCell.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import UIKit
import SDWebImage

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
        guard let imgUrl = news.urlToImage else{return}
        DispatchQueue.main.async {
            self.imgNews.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:"Nophoto"))
        }
        title.text = news.title
        author.text = news.author ?? "Reliable Source"
        desc.text = news.description
    }
}
