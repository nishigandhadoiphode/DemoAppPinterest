//
//  ImageCell.swift
//  PinterestApp
//
//  Created by Nishigandha on 24/05/21.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imageViewLike: UIImageView!
    @IBOutlet var lbllikes: UILabel!

    override func awakeFromNib() {
      super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func fillCellInfo(_ imageData: ImageCellViewModel) {
        self.imageView.image = imageData.image
        self.lblName.text = imageData.name
        self.imageViewLike.image = imageData.isLike ? UIImage(named: "heart_fill") : UIImage(named: "heart_empty")
        self.lbllikes.text = imageData.likes
    }

}
