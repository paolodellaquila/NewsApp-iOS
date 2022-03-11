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
    
    fileprivate func setTitle(_ title: String) {
        titleLabel.text = title
        
        titleLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
    }
    
    fileprivate func setCover(_ imageUrl: String?) {
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)
            coverImage.kf.setImage(with: url, placeholder: UIImage(named: "news_paper_cover"))
            
        }else{
            coverImage.image = UIImage(named: "news_paper_cover")
        }
        
        coverImage.contentMode = .scaleAspectFill
        coverImage.layer.masksToBounds = true

    }
    
    func setupCell(_ title: String, _ imageUrl: String?){
        
        setTitle(title)
        
        setCover(imageUrl)

    }

}
