//
//  GCDDataManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 12/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class GCDDataManager {
    let queue = DispatchQueue(label: "saveQueue", attributes: .concurrent)
    let readWriteManager = ReadOrWriteManager.shared
    
    func saveImageToFile(selectedImage: UIImage) {
        queue.async {
            self.readWriteManager.saveImageToFile(selectedImage: selectedImage)
        }
    }
    
    func getImageFromFile() -> UIImage {
        var image = UIImage()
        queue.async {
            image =  self.readWriteManager.getImageFromFile()
        }
        return image
    }
    
    func getInfoFromTxt(nameOfFile: String) -> String {
        var text = ""
        queue.async {
            text = self.readWriteManager.getInfoFromTxt(nameOfFile: nameOfFile)
        }
        return text
    }
    
    func setInfoToTxt(nameOfFile: String, text: String) {
        queue.sync {
            self.readWriteManager.setInfoToTxt(nameOfFile: nameOfFile, text: text)
        }
    }
}
