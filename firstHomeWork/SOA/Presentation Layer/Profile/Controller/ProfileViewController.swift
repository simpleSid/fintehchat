//
//  ViewController.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 07/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var setFotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let saveQueue = GCDDataManager()
//    let methods = GCDDataManager().readWriteManager
    let readWriteManager = ReadOrWriteManager.shared
    var nameText = ""
    var descrText = ""
    var currentImage = UIImage()
    
    override func viewDidLoad() {
        
        nameText = self.nameTextField.text!
        descrText = self.descriptionTextView.text!
        currentImage = self.profileImageView.image!
        
        descriptionTextView.delegate = self
        
        setFotoButton.isEnabled = false
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
        
        super.viewDidLoad()
        self.initSubViews()
        
//        loadProfileDataWithGCD()
        //loadProfileDataWithOperations()
        // загружаем из кор дата
        loadProfileFromfoCoreData()
        
        activityIndicatorView.hidesWhenStopped = true
        nameTextField.addTarget(self, action: #selector(nameChanged(_:)), for: .allEditingEvents)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if descrText != textView.text {
            self.gcdButton.isEnabled = true
            self.operationButton.isEnabled = true
            descrText = textView.text!
        } else {
            self.gcdButton.isEnabled = false
            self.operationButton.isEnabled = false
        }
    }
    
    @objc func nameChanged(_ sender: UITextField) {
        if nameText != sender.text {
            self.gcdButton.isEnabled = true
            self.operationButton.isEnabled = true
            nameText = sender.text!
        } else {
            self.gcdButton.isEnabled = false
            self.operationButton.isEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.changeFramesForImage()
    }
    
    @IBAction func showActionPressed(_ sender: UIButton) {
        self.displayFotoMenu()
    }
    
    @IBAction func startEdit(_ sender: UIButton) {
        self.editButton.isHidden = true
        self.gcdButton.isHidden = false
        self.operationButton.isHidden = false
        
        self.gcdButton.isEnabled = false
        self.operationButton.isEnabled = false
        
        setFotoButton.isEnabled = true
        nameTextField.isEnabled = true
        descriptionTextView.isEditable = true
    }
    
    
    @IBAction func saveDataWithGCD(_ sender: UIButton) {
        setFotoButton.isEnabled = false
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
        
        self.activityIndicatorView.startAnimating()
        self.gcdButton.isEnabled = false
        self.operationButton.isEnabled = false
        
//        self.methods.saveImageToFile(selectedImage: self.profileImageView.image!)
//        self.methods.setInfoToTxt(nameOfFile: self.methods.nameFile, text: self.nameTextField.text!)
//        self.methods.setInfoToTxt(nameOfFile: self.methods.descriptionFile, text: self.descriptionTextView.text!)
        
        // сохранение в кор дату
        CoreDataManager.shared.saveCurrentProfile(myProfile: self.getLastProfileState(), completion: nil)
        showOkAlert()

//        if methods.flag {
//            showOkAlert()
//        } else {
//            showErrorAlert()
//        }
        
        self.activityIndicatorView.stopAnimating()
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        
        self.editButton.isHidden = false
        self.gcdButton.isHidden = true
        self.operationButton.isHidden = true
    }
    
    // загружаем данные из кор дата
    func loadProfileFromfoCoreData() {
        let profile = CoreDataManager.shared.getCurrentProfile()
        
        self.nameTextField.text = profile.name
        self.descriptionTextView.text = profile.description
        self.profileImageView.image = profile.image
    }
    
    @IBAction func saveDataWithOperation(_ sender: UIButton) {
        setFotoButton.isEnabled = false
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
        
        self.activityIndicatorView.startAnimating()
        self.gcdButton.isEnabled = false
        self.operationButton.isEnabled = false
        
        
        // сохранение в кор дату
        CoreDataManager.shared.saveCurrentProfile(myProfile: self.getLastProfileState(), completion: nil)
        showOkAlert()
        
        
//        let operationManager = OperationDataManager()
//        let saveNameOperation = SaveDataOperation(fileName: readWriteManager.nameFile, text: self.nameTextField.text!)
//        let saveDescriptionOperation = SaveDataOperation(fileName: readWriteManager.descriptionFile, text: self.descriptionTextView.text!)
//        let saveImageOperation = SaveImageOperation(image: self.profileImageView.image!)
//
//        operationManager.operationQueue.addOperation(saveNameOperation)
//        operationManager.operationQueue.addOperation(saveDescriptionOperation)
//        operationManager.operationQueue.addOperation(saveImageOperation)
//        if methods.flag {
//            showOkAlert()
//        } else {
//            showErrorAlert()
//        }
        
        self.activityIndicatorView.stopAnimating()
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        
        self.editButton.isHidden = false
        self.gcdButton.isHidden = true
        self.operationButton.isHidden = true
    }
    
    
    @IBAction func doneEdit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // получить текущее состояние профиля
    func getLastProfileState() -> MyProfile {
        return MyProfile(name: self.nameTextField.text, description: self.descriptionTextView.text, image: self.profileImageView.image)
    }
    
    func showOkAlert() {
        let alertController = UIAlertController(title: nil, message: "данные сохранены", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController,animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Оибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        let repeatAction = UIAlertAction(title: "повторить", style: .default) { (action) in
//            self.methods.saveImageToFile(selectedImage: self.profileImageView.image!)
//            self.methods.setInfoToTxt(nameOfFile: self.methods.nameFile, text: self.nameTextField.text!)
//            self.methods.setInfoToTxt(nameOfFile: self.methods.descriptionFile, text: self.descriptionTextView.text!)
//            if self.methods.flag {
//                self.showOkAlert()
//            } else {
//                self.showErrorAlert()
//            }
        }
        alertController.addAction(okAction)
        alertController.addAction(repeatAction)
        present(alertController,animated: true, completion: nil)
    }
}


