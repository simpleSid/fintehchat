//
//  ViewControllerExtension.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 19/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController {
    func initSubViews() {
        self.profileImageView.clipsToBounds = true
        self.setFotoButton.clipsToBounds = true
       
        //работа с темой
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        self.setFotoButton.layer.borderColor = ThemeManager.currentTheme().titleTextColor.cgColor
        
        self.gcdButton.layer.cornerRadius = 15
        self.gcdButton.layer.borderWidth = 1
        self.gcdButton.layer.borderColor = ThemeManager.currentTheme().titleTextColor.cgColor
        self.gcdButton.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        
        self.operationButton.layer.cornerRadius = 15
        self.operationButton.layer.borderWidth = 1
        self.operationButton.layer.borderColor = ThemeManager.currentTheme().titleTextColor.cgColor
        self.operationButton.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        
        self.nameTextField.textColor = ThemeManager.currentTheme().titleTextColor
        self.nameTextField.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.nameTextField.layer.borderColor = ThemeManager.currentTheme().titleTextColor.cgColor
        self.nameTextField.layer.cornerRadius = 15
        self.nameTextField.layer.borderWidth = 1
        
        self.descriptionTextView.textColor = ThemeManager.currentTheme().titleTextColor
        self.descriptionTextView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.descriptionTextView.layer.borderColor = ThemeManager.currentTheme().titleTextColor.cgColor
        self.descriptionTextView.layer.cornerRadius = 15
        self.descriptionTextView.layer.borderWidth = 1
        
        gcdButton.isHidden = true
        operationButton.isHidden = true
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = ThemeManager.currentTheme().titleTextColor.cgColor
    }
    
    func changeFramesForImage() {
        self.profileImageView.layer.cornerRadius = self.setFotoButton.frame.width / 2
        self.setFotoButton.layer.cornerRadius = self.setFotoButton.frame.width / 2
        self.setFotoButton.imageEdgeInsets = UIEdgeInsets(
            top: self.setFotoButton.frame.width / 6,
            left: self.setFotoButton.frame.width / 6,
            bottom: self.setFotoButton.frame.width / 6,
            right: self.setFotoButton.frame.width / 6)
    }
    
    func displayFotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addFotoFromGallery = UIAlertAction(title: "выбрать фото", style: .default, handler: { (_) in
            self.chooseImagePickerAction(source: .photoLibrary)
        })
        let addFotoFromCamera = UIAlertAction(title: "сделать фото", style: .default, handler: { (_) in
            self.chooseImagePickerAction(source: .camera)
        })
        let deleteFoto = UIAlertAction(title: "удалить фото", style: .destructive) { (_) in
            self.profileImageView.image = UIImage(named: "placeholder-user")
        }
        let cancel = UIAlertAction(title: "отмена", style: .cancel, handler: nil)
        alertController.addAction(addFotoFromCamera)
        alertController.addAction(addFotoFromGallery)
        alertController.addAction(deleteFoto)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let sourceName = source == .camera ? "камера": "галерея"
            let alertControl = UIAlertController(title: "\(sourceName) не доступна", message: "разрешите доступ в настройках", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .destructive, handler: nil)
            alertControl.addAction(okAction)
            self.present(alertControl, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
// work with gsd and operation
extension ProfileViewController {
    
    func loadProfileDataWithGCD() {
//        self.nameTextField.text = ReadOrWriteManager.shared.getInfoFromTxt(nameOfFile: methods.nameFile)
//        self.descriptionTextView.text = ReadOrWriteManager.shared.getInfoFromTxt(nameOfFile: methods.descriptionFile)
//        self.profileImageView.image = ReadOrWriteManager.shared.getImageFromFile()
    }
    
    func loadProfileDataWithOperations() {
        var nameText = ""
        var descrText = ""
        let operationManager = OperationDataManager()
        operationManager.operationQueue.addOperation {
            nameText = self.readWriteManager.getInfoFromTxt(nameOfFile: self.readWriteManager.nameFile)
            descrText = self.readWriteManager.getInfoFromTxt(nameOfFile: self.readWriteManager.descriptionFile)
        }
        self.profileImageView.image = self.readWriteManager.getImageFromFile()
        self.nameTextField.text = nameText
        self.descriptionTextView.text = descrText
    }
    
}
