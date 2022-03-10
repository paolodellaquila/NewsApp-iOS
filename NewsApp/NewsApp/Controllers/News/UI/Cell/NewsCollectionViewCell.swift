//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 06/03/22.
//

import UIKit
import Kingfisher

class NewsCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ title: String, _ imageUrl: String?){
        
        titleLabel.text = title
        
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)
            coverImage.kf.setImage(with: url, placeholder: UIImage(named: "news_paper_cover"))
            
        }else{
            coverImage.image = UIImage(named: "news_paper_cover")
        }
        
        coverImage.contentMode = .scaleAspectFill

    }

}
