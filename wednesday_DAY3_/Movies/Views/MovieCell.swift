//
//  MovieCell.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"

    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    func configureCell(title: String?, overview: String?, imageData: Data?) {
        movieTitleLabel.text = title
        movieOverviewLabel.text = overview
        movieImageView.image = nil
        if let data = imageData {
            movieImageView.image = UIImage(data: data)
        }
    }


    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}
