//
//  ViewController.swift
//  DemoAppPinterest
//
//  Created by Nishigandha on 29/05/21.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController {
    @IBOutlet weak var indicatorImageView: UIImageView!
    //    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
        do {
            let gif = try UIImage(gifName: "earthRevolving.gif")
            self.indicatorImageView.setGifImage(gif, loopCount: -1)
        } catch let error {
            
        }
    }
    
    
    
    func initialSetup(){
        self.collectionView.isHidden = true
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewModel.showLoading = {
            DispatchQueue.main.async{
                if self.viewModel.isLoading {
                    do {
                        let gif = try UIImage(gifName: "earthRevolving.gif")
                        self.indicatorImageView.setGifImage(gif, loopCount: -1)
                    } catch let error {
                        print("GIF image failed to load: %@",error.localizedDescription)
                    }
                    self.collectionView.isHidden = true
                } else {
                    self.indicatorImageView.stopAnimatingGif()
                    self.collectionView.isHidden = false
                }
            }
        }
        viewModel.showError = { error in
            print(error)
            
            switch error {
            case CustomError.serverError:
                let alert = UIAlertController.init(title: "Error", message: CustomError.serverError.description, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "Try Again?", style: .default) { isOK in
                    self.initialSetup()
                }
                alert.addAction(okBtn)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                break
                
            case CustomError.imageDownloadError:
                break
                
            case CustomError.networkError:
                let alert = UIAlertController.init(title: "Error", message: CustomError.networkError.description, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "Try Again?", style: .default) { isOK in
                    self.initialSetup()
                }
                alert.addAction(okBtn)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                break
                
            case CustomError.unknownError:
                break
                
            default:
                break
                
            }
            
        }
        viewModel.reloadData = {
            refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
        viewModel.getPinterestFeeds()
    }
    
    @objc func pullToRefresh(refreshControl: UIRefreshControl) {
        
        viewModel.getPinterestFeeds()
    }
}


// MARK: - Flow layout delegate

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.imageCellViewModels[indexPath.item].image
        let height = image.size.height
        
        return height
    }
}

// MARK: Data source

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let imageData = viewModel.imageCellViewModels[indexPath.item]
        cell.fillCellInfo(imageData)
        return cell
    }
}



