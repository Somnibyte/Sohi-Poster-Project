//
//  ViewController.swift
//  Sohi Poster App
//
//  Created by Guled on 2/18/18.
//  Copyright © 2018 Somnibyte. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "SOHIRESOURCE", bundle: nil) else {
            fatalError("Assets are missing.")
        }
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
            guard
                // Here we save our portal scene.
                let sohiScene = SCNScene(named: "Sohi.scnassets/sohilogo.scn"),
                // Then we save the 'Portal' node within that scene file.
                let swiftLogoNode = sohiScene.rootNode.childNode(withName: "sohilogo", recursively: false)
                else { return }
        
        
        if referenceImage.name == "mariokart" {
            performSegue(withIdentifier: "gamePage", sender: self)
        } else {
            node.addChildNode(swiftLogoNode)
        }
    }
}
