//
//  DrinksRepository.swift
//  Drinks
//
//  Created by Daniel Martínez on 26/03/22.
//

import Foundation
import UIKit


final class DrinksRepository {
  
  func getDrinks() {
    if let fileUrl = Bundle.main.url(forResource: "Drinks", withExtension: "plist") {
      do {
        let data = try Data(contentsOf: fileUrl)
        guard let drinks = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:Any]] else { return }
        print()
        saveToDataBase(drinks)
      }
      catch {
        print("We couldn't fetch the drinks data")
      }
    }
  }
  
  func saveToDataBase(_ drinks: [[String:Any]]) {
    guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
    for i in 0..<drinks.count{
      let drink = Drink(context: context)
      drink.name = drinks[i]["name"] as? String
      drink.ingredients = drinks[i]["ingredients"] as? String
      drink.directions = drinks[i]["directions"] as? String
      drink.image = drinks[i]["image"] as? String
    }
    do {
      try context.save()
      print("Se guardó la info")
      UserDefaults.standard.set(true, forKey: "hasPopulatedDB")
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}
