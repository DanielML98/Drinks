//
//  ViewController.swift
//  Drinks
//
//  Created by Daniel Martínez on 26/03/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
  
  @IBOutlet private weak var drinksTableView: UITableView!
  var drinks = [Drink]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Drinks"
    setUpTableView()
    setUpNavBar()
    getDrinks()
  }
  
  private func setUpTableView() {
    self.drinksTableView.dataSource = self
    self.drinksTableView.delegate = self
    self.drinksTableView.register(UINib(nibName: DrinkTableViewCell.reuseIdentifer, bundle: nil), forCellReuseIdentifier: DrinkTableViewCell.reuseIdentifer)
  }
  
  private func setUpNavBar() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddController))
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logOut))
  }
  
  private func getDrinks() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
      self.drinks = try context.fetch(Drink.fetchRequest())
      print(self.drinks)
      DispatchQueue.main.async {
        self.drinksTableView.reloadData()
      }
    }
    catch {
     print("There's no drinks to show 😬")
    }
  }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return drinks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let currentDrink = drinks[indexPath.row]
    guard let drinkName = currentDrink.name,
          let drinkCell = tableView.dequeueReusableCell(withIdentifier: DrinkTableViewCell.reuseIdentifer, for: indexPath) as? DrinkTableViewCell else { return UITableViewCell() }
    drinkCell.drinkNameLabel.text = drinkName
    return drinkCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let currentDrink = drinks[indexPath.row]
    guard let detailVc =  self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
    detailVc.recipe = currentDrink.directions
    detailVc.ingredients = currentDrink.ingredients
    detailVc.drinkImage = currentDrink.image
    detailVc.drinkName = currentDrink.name
    show(detailVc, sender: nil)
  }
  
  @objc func showAddController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let addDrinkVc = storyboard.instantiateViewController(withIdentifier: "addDrinkVC") as? AddDrinkViewController {
      addDrinkVc.completion = { [weak self] in
        self?.getDrinks()
        self?.drinksTableView.reloadData()
      }
      self.present(addDrinkVc, animated: true)
    }
  }
  
  @objc func logOut() {
    do {
      try Auth.auth().signOut()
      guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") else { return }
      (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(for: loginVC)
    } catch {
      let alertController = UIAlertController(title: "Error",
                                              message: "Se ha producido un error al intentar cerrar sesión \(error.localizedDescription)",
                                              preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
      self.present (alertController, animated: true, completion: nil)
    }
  }
  
  
}

