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
        
        // Here we set the ARSCNViews delegate so that we can use the `render(didadd:)` method at line 46.
        sceneView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // First we load the images we want our iPhone to identify.
        // These images are located in the Asset folder under a folder named "SOHIRESOURCE"
        // You need to drop your images in there and you also need to specify the size of those
        // images in meters (or centimeters if you wish).
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "SOHIRESOURCE", bundle: nil) else {
            fatalError("Assets are missing.")
        }
        
        // Here we setup our debug options.
        // We want to show the world origin (the starting point of our app) and the feature
        // points. Feature points represent tiny dots that appear in your app. When you see
        // a couple of tiny yellow dots in your AR app it means your iPhone has identified an object in
        // front of it.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Here we setup our ARWorldTracking configuration.
        // This object helps our iPhone idenifty it's position and orientation in the real world.
        let configuration = ARWorldTrackingConfiguration()
        
        // We set the `detectImages` attribute of our configuration to `referenceImages`.
        // These means that we want our iPhone to detect the images we loaded earlier and the images
        // we want to detect are found within the `referenceImages` variable.
        configuration.detectionImages = referenceImages
        
        // Here we run our configuration. We also include two options. Reset Tracking
        // basically resets your AR app. And 'removeExistingAnchors' removes all
        // anchors (information that encodes the position, orientation and size of a real world object)
        // from your scene.
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    
    // The render method provides us with two imporant parameters (we will ignore 'renderer' for now,
    // it's not that important for this example). The `node` parameter is a invisible 3D representation
    // of what your iPhone has identified in your scene. So for example if your iPhone saw a poster, it would
    // map an invisible 3D object to that poster (say a flat invisible plane) so that it can refer to it
    // later if it were to ever see it again.
    
    
    // The 'anchor' parmater represents the position, orientation and size of what your iPhone saw.
    // So if we use our poster example from earlier, you can find the position, size and orientation
    // of that poster using the 'anchor' parameter.
    
    
    // Note that the anchor parameter can also be used to identify what exactly your iPhone was looking at.
    // There are a couple of different "Anchors" such as a planeAnchor. There is an example on line 84.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Here we check if the anchor that our iPhone just saw was an image anchor (an image in the real world)
        // If it's not an image anchor (or an image in the real world) then we return, becuase the purpose of our app is to look for images.
        // We could switch `ARImageAnchor` for `ARPlaneAnchor` if we wanted to only identify planes for example.
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        // Now that we have identified an image in the real world we can extract the reference image
        // associated with that imageAnchor.
        let referenceImage = imageAnchor.referenceImage
        
        // Here we simply load our 3D model which can be found in the Sohi.scnassets folder.
            guard
                // Here we save our Sohi scene.
                let sohiScene = SCNScene(named: "Sohi.scnassets/sohilogo.scn"),
                // Then we save the Swift logo 3D model within that scene file.
                let swiftLogoNode = sohiScene.rootNode.childNode(withName: "sohilogo", recursively: false)
                else { return }
        
        
        // If you look in the images found in the SOHISOURCE folder in the Assets folder you can see that
        // I named one of the images (the game box) "mariokart". Here we simply check if the image we are
        // looking at has the name "mariokart". If it does we simply show another view controller that has
        // information about that game.
        if referenceImage.name == "mariokart" {
            performSegue(withIdentifier: "gamePage", sender: self)
        } else {
            // Otherwise we place a 3D logo (the 3D model we loaded on line 94) on top of the
            // 3D model representation of the poster (or game box) our iPhone just saw.
            node.addChildNode(swiftLogoNode)
        }
    }
}
