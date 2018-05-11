//
//  ViewController.swift
//  AR-Photoday
//
//  Created by CCH on 7/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ModelSettingDelegate {


    @IBOutlet weak var sceneView: ARSCNView!
    var colourArr = ["ff0000","00ff00"]
    var nameArr = ["Colour 1","Colour 2"]
    
    
    var theColor = true
    
    var chosenModel: String = ""
    var nodeToAdd: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the Nav Bar
        self.navigationController?.isNavigationBarHidden = true
        
        // Set up scene view
        setUpSceneView(for: sceneView)
        configLighting(for: sceneView)
        
        // Build scene view's scene
        let scene = SCNScene()
        
        // set the scene to the view
        sceneView.scene = scene

        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        
        
        sceneView.addGestureRecognizer(tapGesture)

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Nav Bar
        self.navigationController?.isNavigationBarHidden = true

        // Run the view's session
        setUpSceneView(for: sceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide the Nav Bar
        self.navigationController?.isNavigationBarHidden = false

        // Pause the view's session
        sceneView.session.pause()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - Scene view settings
    // Set up a AR scene view
    func setUpSceneView(for view: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        view.session.run(configuration)
        
        view.delegate = self
        view.showsStatistics = true // Show statistics such as fps and timing information
        view.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    // Configure lighting issues
    func configLighting(for view: ARSCNView) {
        view.autoenablesDefaultLighting = true
        view.automaticallyUpdatesLighting = true
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ModelSetting {
            destination.delegate = self
            destination.modelColour=colourArr
            destination.modelSpec=nameArr
        }
    }
    
    // MARK: Unwind segue
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        switch(segue.identifier) {
        case "AddModel":
            // Load model
            print("Chosen model: " + chosenModel)
            guard let scene = SCNScene(named: chosenModel, inDirectory: "art.scnassets", options: nil) else { return }
            // Pack model contents to a new node
            nodeToAdd = SCNNode.init()
            for node in scene.rootNode.childNodes as [SCNNode] {
                nodeToAdd!.addChildNode(node)
            }
            // Show available planes, ready to receive for tap action (see @singleTapHandler)
            toggleNodeVisibility(name: "plane", in: sceneView, visibility: true)
            break
        default:
            break
        }
    }
    
    // MARK: - UI button actions
    // Reload the scene (re-initialize all models)
    @IBAction func reloadScene(_ sender: Any) {
        print("Reloading")
    }
    
    // Open settings page
    @IBAction func openSettings(_ sender: Any) {
    }
    
    // Take a photo and save to album
    @IBAction func takePhoto(_ sender: Any) {
        let image = sceneView.snapshot()
        
        let shutterView = UIView(frame: sceneView.frame)
        shutterView.backgroundColor = UIColor.black
        view.addSubview(shutterView)
        UIView.animate(withDuration: 0.3, animations: {
            shutterView.alpha = 0
        }, completion: { (_) in
            shutterView.removeFromSuperview()
        })

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - ARSessionObserver
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    // MARK: - Other functions
    func toggleNodeVisibility(name: String, in view: ARSCNView, visibility: Bool) {
        // Set all nodes with the specified name to have specified visibility
        view.scene.rootNode.enumerateChildNodes {(node,_) in
            if node.name == name {
                node.isHidden = !visibility
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func changeObjectColour(_ colour: [String]!) {
        //case balloon arch
        print("changing objet Color")
        colourArr=colour
        let bridge = sceneView.scene.rootNode.childNode(withName: "bridge", recursively: false)!
        let firstColor = sceneView.scene.rootNode.childNode(withName: "first_Arc", recursively: true)!.childNodes[0]
        let secondColor = sceneView.scene.rootNode.childNode(withName: "second_Arc", recursively: true)!.childNodes[0]
        firstColor.geometry!.firstMaterial!.emission.contents = hexStringToUIColor(hex: colour[0])
        secondColor.geometry!.firstMaterial!.emission.contents = hexStringToUIColor(hex: colour[1])
    }
    
    // MARK: - Gesture handlers
    @objc
    func singleTapHandler(_ recognizer: UIGestureRecognizer) {
        // Add a model node to scene
        if let objNode = nodeToAdd {
            // 1. Retrieve hit test results
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            
            // 2. Get target position
            guard let hitTestResult = hitTestResults.first else { return }
            let translation = hitTestResult.worldTransform.columns.3
            
            // 3. Add object to the plane
            objNode.position = SCNVector3(translation.x, translation.y, translation.z)
            sceneView.scene.rootNode.addChildNode(objNode)
            
            // 4. Hide planes, reset nodeToAdd and chosen model
            toggleNodeVisibility(name: "plane", in: sceneView, visibility: false)
            nodeToAdd = nil
            chosenModel = ""
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    


}

// ############################################################################################
// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Adding plane")
        
        // 1. Get plane anchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2. Set up plane
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3. Set plane color
        plane.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        
        // 4. Bind plane to node
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "plane"
        let x = Float(planeAnchor.center.x)
        let y = Float(planeAnchor.center.y)
        let z = Float(planeAnchor.center.z)
        planeNode.position = SCNVector3Make(x, y, z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.isHidden = (self.nodeToAdd == nil)
        
        // 5. Add plane node
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update plane
        // 1. Get plane anchors and plane
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2. Update plane width and depth
        let width = CGFloat(planeAnchor.extent.x)
        let depth = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = depth
        
        // 3. Update plane node position
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}
