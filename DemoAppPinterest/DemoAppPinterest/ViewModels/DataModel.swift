//
//  DataModel.swift
//  DemoAppPinterest
//
//  Created by Nishigandha on 29/05/21.
//

import UIKit
import Kingfisher

enum CustomError: Error {
    case networkError
    case imageDownloadError
    case unknownError
    case serverError
}

extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .networkError:
            return "Please check your internet and Try Again!"
        case .imageDownloadError:
            return "The specified image URL could not fetch the image."
        case .unknownError:
            return "An unexpected error occurred."
        case .serverError:
            return "Server data could not be fetched at this moment."
        }
    }
}

struct ImageCellViewModel {
    let image: UIImage
    let name: String
    let isLike: Bool
    let likes: String
}

class ViewModel {
    // MARK: Properties

    private var picture: [PinterestFeed] = [] {
        didSet {
            self.downloadPicture()
        }
    }
    var imageCellViewModels: [ImageCellViewModel] = []

    // MARK: UI

    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?

    init() {

    }

    func getPinterestFeeds() {
        
        self.isLoading = true
        let didReach:Reachability! = Reachability()
        if didReach.isReachable {
            PinterestAPICalls.getPinterestFeeds { isSuccess, feeds, err in
                if isSuccess {
                    self.picture = feeds!
                }else{
                    self.isLoading = false
                    self.showError?(CustomError.serverError)
                }
            }
        } else {
            self.isLoading = false
            self.showError?(CustomError.networkError)
        }

    }

    private func downloadPicture() {
        let group = DispatchGroup()
        self.picture.forEach { (photo) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                
                guard let url = URL.init(string: photo.urls.small) else {
                    return
                }

                let resource = ImageResource(downloadURL: url, cacheKey: photo.urls.small)
                KingfisherManager.shared.retrieveImage(with: resource, options:[.cacheOriginalImage] , progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                        self.imageCellViewModels.append(ImageCellViewModel(image: value.image, name: photo.user.name, isLike: photo.liked_by_user, likes:"\(photo.likes ?? 0)"))

                    case .failure(let error):
                        print("KingFisher Error: \(error)")
                        self.showError?(CustomError.imageDownloadError)
                        self.imageCellViewModels.append(ImageCellViewModel(image: UIImage(named: "placeholder-image")!, name:photo.user.name, isLike: photo.liked_by_user, likes: "\(photo.likes ?? 0)"))
                        group.notify(queue: .main) {
                            self.isLoading = false
                            self.reloadData?()
                        }

                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }


}
