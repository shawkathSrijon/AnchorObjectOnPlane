//
//  Model.swift
//  AnchorObjectOnPlane
//
//  Created by Simec Sys Ltd. on 4/10/20.
//

import UIKit
import RealityKit
import Combine

class Model: Identifiable {
    let id = UUID()
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: self.modelName)!
        
        let fileName = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                print("Unable to load modelEntity for modelName: \(modelName)")
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
            })
    }
}
