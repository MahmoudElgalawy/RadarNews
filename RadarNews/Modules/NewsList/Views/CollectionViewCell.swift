//
//  CollectionViewCell.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        vBack.layer.cornerRadius = 10
        imgNews.layer.cornerRadius = 10
        vBack.layer.masksToBounds = true
    }
    static func nib()->UINib{
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    func configureCell(news:News){
        
    }
}
