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
    drinkImageView.image = getDrinkImage()
    ingredientsLabel.text = ingredients ?? "Sorry 😢\n We couldn't find the ingredients"
    recipeLabel.text = recipe ?? "Turns out we don't really know how to make this drink 🙃"
  }
  
  private func getDrinkImage() -> UIImage {
    if fileExists(),
    let image = UIImage(contentsOfFile: drinkName!){
      return image
    } else if let assetImage = UIImage(named: drinkImage!) {
      return assetImage
    }
    return UIImage(named: "drink-icon") ?? UIImage(systemName: "camera")!
  }
  
  private func fileExists() -> Bool {
    if let path = drinkImage {
      return FileManager.default.fileExists(atPath: path)
    } else {
      return false
    }
  }
}
