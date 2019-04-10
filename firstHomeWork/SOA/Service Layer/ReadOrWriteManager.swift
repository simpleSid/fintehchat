//
//  ReadOrWriteManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 12/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//


import UIKit

class ReadOrWriteManager {
    
    var nameFile = "fileName.txt"
    var descriptionFile = "description.txt"
    var imageFile = "image.jpg"
    var name = ""
    var description = ""
    var flag = true
    
    private init() {}
    static var shared = ReadOrWriteManager()
    
    
    
    // чтение из файла
    func getInfoFromTxt(nameOfFile: String) -> String {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(nameOfFile)
            do {
                flag = true
                return try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {
                flag = false
                print("error in readFile")
                
            }
        }
        return "информация отсутствует"
    }
    
    //пишем текст в файл
    func setInfoToTxt(nameOfFile: String, text: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(nameOfFile)
            do {
                flag = true
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                flag = false
                print("error")
                
            }
        }
    }
    
    // сохранение картинки в файл
    func saveImageToFile(selectedImage: UIImage) {
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self.imageFile)
        print(imagePath)
        let image = selectedImage
        let imageData = image.jpegData(compressionQuality: 1.00)
        FileManager.default.createFile(atPath: imagePath as String, contents: imageData, attributes: nil)
    }
    
    //извлечение картинки из файла
    func getImageFromFile() -> UIImage {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self.imageFile)
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)!
        } else {
            return UIImage(named: "placeholder-user.jpg")!
        }
    }
}

