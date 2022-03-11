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
        let index = title.index(title.startIndex, offsetBy: 30)
        let titleSub = title[..<index]
        titleLabel.text = String(titleSub)
    }
    
    fileprivate func setCover(_ imageUrl: String?) {
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)
            coverImage.kf.setImage(with: url, placeholder: UIImage(named: "news_paper_cover"))
            
        }else{
            coverImage.image = UIImage(named: "news_paper_cover")
        }
        
        coverImage.contentMode = .scaleAspectFill
        coverImage.layer.cornerRadius = coverImage.frame.width/12.0
        coverImage.layer.masksToBounds = true
    }
    
    func setupCell(_ title: String, _ imageUrl: String?){
        
        setTitle(title)
        
        setCover(imageUrl)

    }

}
