//
//  OperationDataManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 12/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class OperationDataManager {
    let operationQueue = OperationQueue()
}

class SaveDataOperation: Operation {
    
    let dataManager = ReadOrWriteManager.shared
    let fileName: String
    let text: String
    
    init(fileName: String, text: String) {
        self.fileName = fileName
        self.text = text
    }
    
    override func main() {
        self.dataManager.setInfoToTxt(nameOfFile: fileName, text: text)
    }
}


class SaveImageOperation: Operation {
    let dataManager = ReadOrWriteManager.shared
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    override func main() {
        dataManager.saveImageToFile(selectedImage: image)
    }
}
