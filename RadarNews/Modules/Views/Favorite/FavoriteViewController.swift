//
//  FavoriteViewController.swift
//  RadarNews
//
//  Created by Mahmoud  on 02/11/2024.
//

import UIKit

class FavoriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var FavCollection: UICollectionView!
    var viewModel:favourite!
    var back:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavCollection.dataSource = self
        FavCollection.delegate = self
        viewModel = FavouriteViewModel()
        back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backButton))
        viewModel.getFavourit()
        setupCollectionView()
        registerCell()
    }
}

// Mark:- UISetUp
extension FavoriteViewController{
    func registerCell(){
       FavCollection.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: "CollectionViewCell")
   }
   private func setupCollectionView(){
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical
       layout.minimumLineSpacing = 2
       layout.minimumInteritemSpacing = 2
   }
    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
       }
   
}

// Mark:- Render CollecctionView
extension FavoriteViewController{
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FavCollection.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.configureCell(news: viewModel.favArr[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let availableWidth = collectionView.frame.width - padding * 3
        let widthPerItem = availableWidth / 2
        let heightPerItem = widthPerItem * 1.5
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        detailsVc.detailsViewModel.newsDetails = viewModel.favArr[indexPath.row]
        detailsVc.navigationItem.title = "Details"
        detailsVc.navigationItem.leftBarButtonItem = back
        detailsVc.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        detailsVc.favBtnIsHidden = true
        navigationController?.pushViewController(detailsVc, animated: true)
    }
}
