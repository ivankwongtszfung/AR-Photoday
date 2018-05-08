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

class ViewController: UIViewController, ARSCNViewDelegate, ModelSettingDelegate{
    
    @IBOutlet weak var sceneView: ARSCNView!
    var colourArr = ["ff0000"]
    var nameArr = ["Colour 1"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        let scene = SCNScene()
        
        let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = hexStringToUIColor(hex: colourArr[0])
        box.materials = [material]

        
        let node = SCNNode()
        node.position = SCNVector3(x:0,y:0.02,z:-0.1)
        node.scale = SCNVector3(x:0.01,y:0.01,z:0.01)
        node.geometry = box
        
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true

        
        // Hide the Nav Bar
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Nav Bar
        self.navigationController?.isNavigationBarHidden = true

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
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
    
    // MARK: - UI button actions
    // Reload the scene (re-initialize all models)
    @IBAction func reloadScene(_ sender: Any) {
        print("Reloading")
    }
    
    // Open settings page
    @IBAction func openSettings(_ sender: Any) {
    }
    
    // Open photo album
    @IBAction func openAlbum(_ sender: Any) {
    }

    // Take a photo and save to album
    @IBAction func takePhoto(_ sender: Any) {
        let image = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    // Add a new model
    @IBAction func addModel(_ sender: Any) {
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ModelSetting {
            destination.delegate = self
            destination.modelColour.append(colourArr[0])
            destination.modelSpec.append(nameArr[0])
        }
    }
    
    func changeObjectColour(_ colour: String?){
        colourArr[0] = colour!
    }


}
