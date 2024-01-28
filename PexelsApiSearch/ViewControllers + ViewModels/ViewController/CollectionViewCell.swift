//
//  CollectionViewCell.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let CELL_IDENTIFIER = "Cell"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.textColor = UIColor.black
    }
}

