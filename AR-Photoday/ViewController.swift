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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
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
}
