//
//  HeroTableViewCell.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 26/1/24.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
	static let nibName = "HeroTableViewCell"
	static let identifier = "heroTableViewIdentifier"
	
	// MARK: - Outlets
	@IBOutlet weak var heroImage: UIImageView!	
	@IBOutlet weak var heroName: UILabel!
	@IBOutlet weak var heroDesciption: UILabel!	
	@IBOutlet weak var chevronImage: UIImageView!
	
	// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
