//
//  ViewController.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import UIKit
import Combine
import CombineDataSources

class ViewController: UIViewController,UICollectionViewDelegate, UISearchResultsUpdating,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var newsCollection: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var indicator : UIActivityIndicatorView?
    let searchController = UISearchController()
    private var viewModel: ListViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Int,News>!
    var back:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator()
        viewModel = ListViewModel(remoteService: Remote())
        imgNoData.isHidden = true
        newsCollection.delegate = self
        searchController.searchResultsUpdater = self
        viewModel.$searchNews
                   .receive(on: RunLoop.main)
                   .sink {  [weak self] news in
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           if news.isEmpty{
                               self?.imgNoData.isHidden = false
                               self?.newsCollection.isHidden = true
                           }else{
                               self?.imgNoData.isHidden = true
                               self?.newsCollection.isHidden = false
                               self?.updateCollectionView(with: news)
                               self?.indicator?.stopAnimating()
                           }}}
                   .store(in: &cancellables)
//        viewModel.$selectedNews
//                .compactMap { $0 }
//                .sink { [weak self] item in
//                    let detailsVc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
//                    detailsVc.detailsViewModel.newsDetails = item
//                    detailsVc.navigationItem.leftBarButtonItem = self?.back
//                    detailsVc.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
//                    self?.navigationController?.pushViewController(detailsVc, animated: true)
//                }
//                .store(in: &cancellables)
        setupCollectionView()
        searchBar()
        registerCell()
        self.hideKeyboardWhenTappedAround()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        fetchNews()
        back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backButton))
    }

    @IBAction func addToFav(_ sender: Any) {
    }
    
}


extension ViewController {
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
    }
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        newsCollection.setCollectionViewLayout(layout, animated: true)
        dataSource = UICollectionViewDiffableDataSource<Int, News>(collectionView: newsCollection) { (collectionView, indexPath, news) -> UICollectionViewCell? in
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.configureCell(news: news)
                   return cell
               }
    }
    func searchBar(){
        searchController.searchBar.tintColor = UIColor.lightGray
        let searchBar = searchController.searchBar
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        if let searchIcon = UIImage(systemName: "magnifyingglass") {
            let tintedImage = searchIcon.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
            searchBar.setImage(tintedImage, for: UISearchBar.Icon.search, state: .normal)
        }
        
        navigationItem.searchController = searchController
    }
    private func updateCollectionView(with news: [News]) {
                var snapshot = NSDiffableDataSourceSnapshot<Int, News>()
                let uniqueNews = Array(Set(news))
                snapshot.appendSections([0])
                snapshot.appendItems(uniqueNews)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            
       }
    func registerCell(){
        newsCollection.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    private func fetchNews() {
            indicator?.startAnimating()
            let date = datePicker.date
            let dateString = formatDate(date: date)
            viewModel.getNews(query: "apple", from: dateString)
        }
    @objc private func dateChanged() {
            fetchNews()
        }
    @objc func backButton() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.popViewController(animated: true)
       }
}


extension ViewController{
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
        detailsVc.detailsViewModel.newsDetails = viewModel.searchNews[indexPath.row]
        detailsVc.navigationItem.leftBarButtonItem = back
        detailsVc.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        navigationController?.pushViewController(detailsVc, animated: true)
    }
}

extension ViewController{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{return}
        viewModel.filterNews(searchText: text)
    }
    
    private func formatDate(date: Date) -> String {
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        _ = dateFormatter.string(from: modifiedDate)
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
}


