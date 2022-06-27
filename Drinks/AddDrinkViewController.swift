//
//  AddDrinkViewController.swift
//  Drinks
//
//  Created by Daniel Martínez on 07/04/22.
//

import UIKit
import Photos

class AddDrinkViewController: UIViewController {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  var completion: (() -> Void)?
  var keyboardIsShowing: Bool?
  let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
  private var customImageName: String? = nil
  @IBOutlet weak var fromScrollView: UIScrollView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var ingredientsTextView: UITextView!
  @IBOutlet weak var instructionsTextView: UITextView!
  @IBOutlet weak var drinkImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    fromScrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    fromScrollView.addGestureRecognizer(tap)
    fromScrollView.isUserInteractionEnabled = true
  }
  
  @objc private func keyboardAppeared() {
    if !(keyboardIsShowing ?? false) {
      self.fromScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.fromScrollView.frame.height + 300)
      keyboardIsShowing = true
    }
  }
  
  @objc private func keyboardDisappeared() {
    if (keyboardIsShowing ?? false) {
      self.fromScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.fromScrollView.frame.height - 300)
      keyboardIsShowing = false
    }
  }
  @IBAction func addTapped(_ sender: Any) {
    self.view.endEditing(true)
    
    if ingredientsTextView.text.isEmpty || instructionsTextView.text.isEmpty || nameTextField.text!.isEmpty {
      
      let alert = UIAlertController(title: "Missing Information", message: "Please fill in all the fields", preferredStyle: .alert)
    
      alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
      
      present(alert, animated: true)
      
    } else {
      
      let drink = Drink(context: self.context)
      
      drink.name = nameTextField.text!
      drink.ingredients = ingredientsTextView.text!
      drink.directions = instructionsTextView.text!
      drink.image = customImageName
      
      do {
        try context.save()
        completion!()
        self.dismiss(animated: true)
      } catch {
        print("Error adding drink, \(error)")
      }
    }
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
    keyboardAppeared()
  }
  
  @IBAction func didTapAddPhoto(_ sender: Any) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      imagePicker.sourceType = .photoLibrary
    }
    imagePicker.allowsEditing = true
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  private func saveImage(_ bytes: Data, _ name: String) {
    let fileURL = libraryURL.appendingPathComponent(name)
    self.customImageName = fileURL.path
    do {
      try bytes.write(to: fileURL)
    } catch {
      print("We couldn't download the photo")
    }
  }
}

extension AddDrinkViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true)
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
       let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
      let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
      let asset = result.firstObject
      guard let data = image.pngData() else { return }
      guard let fileName = asset?.value(forKey: "filename") as? String else { return }
      saveImage(data, fileName)
      drinkImageView.image = image
    }
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("Canceled operation")
    picker.dismiss(animated: true)
  }
}

