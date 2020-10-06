//
//  ModelPickerView.swift
//  AnchorObjectOnPlane
//
//  Created by Simec Sys Ltd. on 4/10/20.
//

import SwiftUI

struct ModelPickerView: View {
    var models: [Model] = {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var existingModels: [Model] = []
        for fileName in files where fileName.hasSuffix("usdz") {
            let modelName = fileName.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            existingModels.append(model)
        }
        return existingModels
    }()
    var size: CGSize
    @Binding var modelForPlacement: Model?

    var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(models) { model in
                        Button(action: {
                            modelForPlacement = model
                        }) {
                            Image(uiImage: UIImage(named: model.modelName)!)
                                .resizable()
                                .frame(height: 75)
                                .aspectRatio(1/1, contentMode: .fit)
                                .cornerRadius(6)
                        }
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.3))
            .frame(width: size.width * 0.95)
            .cornerRadius(10)
    }
}

//struct ModelPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModelPickerView()
//    }
//}
