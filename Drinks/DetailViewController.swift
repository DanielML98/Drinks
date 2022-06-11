//
//  DetailViewController.swift
//  Drinks
//
//  Created by Daniel Martínez on 26/03/22.
//

import UIKit

class DetailViewController: UIViewController {
  var drinkImage: String?
  var ingredients: String?
  var recipe: String?
  var drinkName: String?
  
  @IBOutlet weak var drinkImageView: UIImageView!
  @IBOutlet weak var ingredientsLabel: UILabel!
  @IBOutlet weak var recipeLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = drinkName ?? ""
    drinkImageView.image = UIImage(named: drinkImage ?? "drink-icon")
    ingredientsLabel.text = ingredients ?? "Sorry 😢\n We couldn't find the ingredients"
    recipeLabel.text = recipe ?? "Turns out we don't really know how to make this drink 🙃"
  }
  
}
