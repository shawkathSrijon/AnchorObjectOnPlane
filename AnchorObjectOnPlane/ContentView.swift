//
//  ContentView.swift
//  AnchorObjectOnPlane
//
//  Created by Simec Sys Ltd. on 4/10/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State private var modelForPlacement: Model?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ARViewContainer(modelForPlacement: $modelForPlacement)
                    .edgesIgnoringSafeArea(.all)
                ModelPickerView(size: geometry.size, modelForPlacement: $modelForPlacement)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let coachingOverlay = ARCoachingOverlayView(frame: arView.frame)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        arView.addSubview(coachingOverlay)
        
        coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor).isActive = true
        coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor).isActive = true
        coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor).isActive = true
        coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor).isActive = true
        
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView.session
        
        arView.session.run(configuration)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = modelForPlacement {
            if let modelEntity = model.modelEntity {
                let anchorEntity = AnchorEntity(plane: .horizontal)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("Unable to load modelEntity \(model.modelName)")
            }
            DispatchQueue.main.async {
                modelForPlacement = nil
            }
        }
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
