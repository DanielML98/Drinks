//
//  DrinkTableViewCell.swift
//  Drinks
//
//  Created by Daniel Martínez on 26/03/22.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

  @IBOutlet weak var drinkNameLabel: UILabel!
  static let reuseIdentifer: String = String(describing: DrinkTableViewCell.self)
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
