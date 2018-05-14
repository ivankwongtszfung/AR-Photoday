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
import ReplayKit
import Toast_Swift
import Photos
import AVFoundation

class ViewController: UIViewController, ModelSettingDelegate {

    


    @IBOutlet weak var setting: UIButton!
    @IBOutlet weak var refresh: UIButton!
    @IBOutlet weak var gallery: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var snap: SnapButton!
    @IBOutlet weak var sceneView: ARSCNView!
    var colourArr = ["ff0000","00ff00"]
    var nameArr = ["Colour 1","Colour 2"]
    var theColor = true
    
    let ELIGIBLE_OBJ = ["Sphere","bridge"]
    var ELIGIBLE_MODEL = ["bubbleArch"]

    var chosenModel: String = ""
    var nodeToAdd: SCNNode?
    
    var selectedNode: SCNNode?
    
    let recorder = RPScreenRecorder.shared()
    
    var toastStyle = ToastStyle(), toastImportantStyle = ToastStyle()
    
    enum permission { case camera, album }

    // MARK: - ViewController
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

        // Single tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        // Double tap gesture recognizer
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapHandler(with:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTapRecognizer)
        
        // Pinch gesture recognizer
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchHandler(with:)))
        sceneView.addGestureRecognizer(pinchRecognizer)
        
        // Rotation gesture recognizer
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.rotationHandler(with:)))
        sceneView.addGestureRecognizer(rotationRecognizer)
        
        // Pan gesture recognizer
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(with:)))
        sceneView.addGestureRecognizer(panRecognizer)
        
        // Long gesture recognizer (on snap button)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(record(sender:)))
        snap.addGestureRecognizer(longGesture)

        // Set up Toast settings
        toastStyle.maxWidthPercentage = 0.9
        toastStyle.messageAlignment = .center
        toastImportantStyle = toastStyle
        toastImportantStyle.backgroundColor = .red
        ToastManager.shared.style = toastStyle
        ToastManager.shared.position = .top
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure camera permission is granted
        let permission = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch(permission) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if !granted { self.requestPermission(permission: ViewController.permission.camera) }
            }
            break
        case .authorized:
            break
        default:
            requestPermission(permission: ViewController.permission.camera)
        }
        
        // Hide the Nav Bar
        self.navigationController?.isNavigationBarHidden = true

        // Run the view's session
        setUpSceneView(for: sceneView)
        configLighting(for: sceneView)
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
    
    // MARK: - Scene view settings
    // Set up a AR scene view
    func setUpSceneView(for view: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        view.session.run(configuration)
        
        view.delegate = self
        view.debugOptions = []
    }
    
    // Configure lighting issues
    func configLighting(for view: ARSCNView) {
        view.autoenablesDefaultLighting = true
        view.automaticallyUpdatesLighting = true
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ColourTexture {
            destination.delegate = self
            print("segue prepare")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch(identifier) {
        case "SelectModel":
            // If in normal mode: Go to choose model
            if nodeToAdd == nil { return true }
            else {
                // If in add mode: return to cancel mode
                clearNodeToAdd(in: sceneView)
                print("Cancelled adding")
                self.showToast("Cancelled adding")
                return false
            }
        case "ShowGallery", "ShowSettings":
            return true
        default:
            print("Unrecognized segue identifier: \(identifier)")
            return false
        }
    }
    
    // MARK: Unwind segue
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        switch(segue.identifier) {
        case "AddModel":
            // Load model
            print("Chosen model: " + chosenModel)
            guard let scene = SCNScene(named: chosenModel, inDirectory: "art.scnassets", options: nil) else { return }
            // Clone node contents to a new node
            let newNode = scene.rootNode.clone()
            newNode.geometry = scene.rootNode.geometry?.copy() as? SCNGeometry
            nodeToAdd = newNode
            
            // Show available planes
            toggleNodeVisibility(name: "plane", in: sceneView, visibility: true)
            
            // Ready to receive for tap action (see @singleTapHandler)
            let name = nodeToAdd?.name ?? ""
            self.showToast("Tap on a plane/point to add model \(name)")
            
            // Change add button to cancel button
            self.add.transform = self.add.transform.rotated(by: .pi/4)
            break
        default:
            break
        }
    }
    
    // MARK: - UI button actions
    // Reload the scene (restart or just remove all models)
    @IBAction func reloadScene(_ sender: Any) {
        let configuration = self.sceneView.session.configuration!
        
        // Pause the session
        sceneView.session.pause()
        
        // Show action sheet
        let dialog = UIAlertController(title: nil, message: "Choose an Action", preferredStyle: .actionSheet)
        let removeModelAction = UIAlertAction(title: "Remove all models", style: .destructive) { (_) in
            // Delete all eligible nodes
            self.sceneView.scene.rootNode.enumerateChildNodes {(node,_) in
                if self.strMatchArray(array: self.ELIGIBLE_OBJ, node: node) || self.strMatchArray(array: self.ELIGIBLE_MODEL, node: node) {
                    node.removeFromParentNode()
                }
            }
            // Resume the session
            self.sceneView.session.run(configuration)
            self.showToast("All models removed")
            return
        }
        let restartAction = UIAlertAction(title: "Restart the app", style: .destructive) { (_) in
            // Delete all nodes
            self.sceneView.scene.rootNode.enumerateChildNodes {(node,_) in
                node.removeFromParentNode()
            }
            // Start the session again
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            self.showToast("App restarted")
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.sceneView.session.run(configuration)
        }
        dialog.addAction(removeModelAction)
        dialog.addAction(restartAction)
        dialog.addAction(cancelAction)
        self.present(dialog, animated: true, completion: nil)
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

        let permission = PHPhotoLibrary.authorizationStatus()
        switch(permission) {
        case .authorized:
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.authorized { UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) }
            }
            break
        default:
            requestPermission(permission: ViewController.permission.album)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Video recording
    @objc func record(sender : UIGestureRecognizer){
        if sender.state == .ended {
            snap.isHidden = false
            setting.isHidden = false
            refresh.isHidden = false
            gallery.isHidden = false
            add.isHidden = false
            recorder.stopRecording(){ (previewVC, error) in
                if let previewVC = previewVC{
                    previewVC.previewControllerDelegate = self
                    self.present(previewVC,animated: true,completion: nil)
                }
                if let error = error {
                    self.showToast("Error when stopping recording")
                    print(error)
                }
            }
        }
        else if sender.state == .began {
            snap.isHidden = true
            setting.isHidden = true
            refresh.isHidden = true
            gallery.isHidden = true
            add.isHidden = true
            recorder.startRecording(){ (error) in
                if let error = error {
                    self.showToast("Error when recording")
                    print(error)
                }
            }
        }
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
    
    func changeObjectColour(_ colour: [String]!, _ model: String) {
        //case balloon arch
        print("changing object Color")
        colourArr=colour
        print(model)
        if sceneView.scene.rootNode.childNode(withName: "bridge", recursively: true) != nil{
            let firstColor = sceneView.scene.rootNode.childNode(withName: "first_Arc", recursively: true)!
            let secondColor = sceneView.scene.rootNode.childNode(withName: "second_Arc", recursively: true)!
            print(model)
            if(model == "Texture"){
                firstColor.childNodes[0].geometry!.firstMaterial!.diffuse.contents = UIImage(named: colour[0])
                secondColor.childNodes[0].geometry!.firstMaterial!.diffuse.contents = UIImage(named: colour[1])
                firstColor.childNodes[0].geometry!.firstMaterial!.lightingModel = .phong
                secondColor.childNodes[0].geometry!.firstMaterial!.lightingModel = .phong
            }
            else if(model == "Colour"){
                firstColor.childNodes[0].geometry!.firstMaterial!.diffuse.contents = hexStringToUIColor(hex: colour[0])
                secondColor.childNodes[0].geometry!.firstMaterial!.diffuse.contents = hexStringToUIColor(hex: colour[1])
                firstColor.childNodes[0].geometry!.firstMaterial!.lightingModel = .phong
                secondColor.childNodes[0].geometry!.firstMaterial!.lightingModel = .phong
            }
            return
        }
        
        
        
        //UIImage(named: “earth.jpg”)
    }
    
    // Find the selected node recursively by performing hit test
    func findHitNode(recognizer: UIGestureRecognizer, view: SCNView, recursively: Bool) -> SCNNode? {
        let location = recognizer.location(in: view)
        let hitTestResults = view.hitTest(location)
        
        if recursively {
            // Loop all hit test result before it gives up
            for hitTestResult in hitTestResults {
                var node = hitTestResult.node
                // Perform a DFS search of nodes, until it searches the SCNView's root node
                while (node != view.scene?.rootNode) {
    //                if let name = node.name { print("Searching node: " + name) }
                    if strMatchArray(array: ELIGIBLE_MODEL, node: node) {
    //                    if let name = node.name { print("Selecting node: " + name) }
                        return node
                    } else {
                        // Search its parent node
                        node = node.parent!
                    }
                }
            }
//            print("No node found")
            return nil
        } else {
            // For changing color or material
            //debug
            let name = hitTestResults.first?.node.name
            
            return hitTestResults.first?.node
        }
    }
    
    func strMatchArray(array: Array<String>,node: SCNNode)->Bool{
        
        guard let string = node.name else{
            return false
        }
        return array.contains { (element) -> Bool in return string.contains(element) }
    }
    
    func openModelSettingController(input :UIAlertAction) ->Void {
        if(colourArr.isEmpty || nameArr.isEmpty)
        {
            print("color array and name array should not be empty.")
            return
        }
        if let destination = self.storyboard?.instantiateViewController(withIdentifier: "ModelSetting") as? ModelSetting {
            destination.delegate = self
            destination.modelColour=colourArr
            destination.modelSpec=nameArr
            self.navigationController?.pushViewController(destination, animated: true)
        }
        else{
            print("storyboard dont contain modelsetting  identifier")
        }
        return
    }
    
    func openOptionPage(input:UIAlertAction)->Void{
        if let destination = self.storyboard?.instantiateViewController(withIdentifier: "OptionPage") as? ColourTexture {
            destination.delegate = self
            self.navigationController?.pushViewController(destination, animated: true)
        }
        else{
            print("storyboard dont contain OptionPage identifier")
        }
        return
    }
    
    // Request permission from user (if not permitted)
    func requestPermission(permission: permission) {
        // Hide previous toasts
        self.view.hideAllToasts()
        // Show permission grant toast
        self.view.makeToast("Permission needed. \nClick for information", duration: 5, style: toastImportantStyle) { (didTap) in
            if didTap {
                var requestText: String
                switch(permission) {
                case .album:
                    requestText = "Album permission is used for adding and accessing photos.\nClick \"Photos\" then click \"Read and Write\" access."
                case .camera:
                    requestText = "Camera permission is required in this app.\nClick the switch button on the \"Camera\" row."
                }
                let dialog = UIAlertController(title: "Permission Request", message: requestText, preferredStyle: .alert)
                let goAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) in
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                dialog.addAction(goAction)
                dialog.addAction(cancelAction)
                self.present(dialog, animated: true, completion: nil)
            }
        }
    }
    
    // Return add mode to cancel mode
    func clearNodeToAdd(in view: ARSCNView) {
        // Hide planes, reset nodeToAdd and chosen model
        toggleNodeVisibility(name: "plane", in: view, visibility: false)
        nodeToAdd = nil
        chosenModel = ""
        // Change cancel button back to add button
        self.add.transform = self.add.transform.rotated(by: .pi/4)
    }
    
    // Show a simple new toast
    func showToast(_ msg: String) {
        // Hide previous toasts
        self.view.hideAllToasts()
        // Show new toast
        self.view.makeToast(msg)
    }
    
    // MARK: - Gesture handlers
    @objc func singleTapHandler(_ recognizer: UIGestureRecognizer) {
        // Case: Adding a model node to scene
        if let objNode = nodeToAdd {
            let name = objNode.name ?? ""
            // 1. Retrieve hit test plane results
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            
            // 2. Find if a plane or a random point is selected
            var hitTestResult: ARHitTestResult?
            if hitTestResults.count > 0 {
                self.showToast("Model \(name) added on a plane")
                // Location is on the plane
                hitTestResult = hitTestResults.first
            } else {
                // Try to find on feature points
                let hitTestPoints = sceneView.hitTest(tapLocation, types: .featurePoint)
                if hitTestPoints.count > 0 {
                    self.showToast("Model \(name) added on a point")
                    // Location is a random point
                    hitTestResult = hitTestPoints.first
                }
            }
            
            // 3. If there is a valid hit test result, place the object node there
            if let result = hitTestResult {
                // Get target position
                let translation = result.worldTransform.columns.3
                
                // Add object to the plane
                objNode.position = SCNVector3(translation.x, translation.y, translation.z)
                sceneView.scene.rootNode.addChildNode(objNode)
                
                // Return add mode to normal mode
                clearNodeToAdd(in: sceneView)
            } else {
                // Display fail message
                self.showToast("Try to place the model again")
            }
        }
    }
    
    @objc func doubleTapHandler(with recognizer: UIGestureRecognizer) {
        // Make sure the node is eligible (has a name)
        guard let node = findHitNode(recognizer: recognizer, view: sceneView, recursively: false), let name = node.name,
            strMatchArray(array: ELIGIBLE_OBJ,node: node) else { return }
        
        // Show action sheet
        let dialog = UIAlertController(title: name, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            node.removeFromParentNode()
            self.showToast("Model \(name) deleted")
        }
        let optionAction = UIAlertAction(title: "Options", style: .default, handler: openOptionPage)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        dialog.addAction(deleteAction)
        dialog.addAction(optionAction)
        dialog.addAction(cancelAction)
        self.present(dialog, animated: true, completion: nil)
    }
    
    @objc func pinchHandler(with recognizer: UIPinchGestureRecognizer) {
        switch(recognizer.state) {
        case .began:
            // Ensure the node is eligible
            guard let node = findHitNode(recognizer: recognizer, view: sceneView, recursively: true) else { return }
            selectedNode = node
            break
        case .changed:
            // 1. Ensure there is a selected node
            guard let node = selectedNode else { return }
            
            // 2. Do scale action
            let action = SCNAction.scale(by: recognizer.scale, duration: 0.1)
            node.runAction(action)
            recognizer.scale = 1
            break
        case .ended:
            // Clear the selected node
            selectedNode = nil
            break
        default:
            break
        }
        
    }
    
    @objc func rotationHandler(with recognizer: UIRotationGestureRecognizer) {
        switch(recognizer.state) {
        case .began:
            // Ensure the node is eligible
            guard let node = findHitNode(recognizer: recognizer, view: sceneView, recursively: true) else { return }
            selectedNode = node
            break
        case .changed:
            // 1. Ensure there is a selected node
            guard let node = selectedNode else { return }
            
            // 2. Do rotation
            let rotation = CGFloat(-1*recognizer.rotation)
            let action = SCNAction.rotateBy(x: 0, y: rotation, z: 0, duration: 0.1)
            node.runAction(action)
            recognizer.rotation = 0
            break
        case .ended:
            // Clear the selected node
            selectedNode = nil
            break
        default:
            break
        }
    }
    
    
    func openColourTextureController(input :UIAlertAction) ->Void
    {
        performSegue(withIdentifier: "OptionPage", sender: self)
        return
    }
    
    
    @objc func panHandler(with recognizer: UIPanGestureRecognizer) {
        switch(recognizer.state) {
        case .began:
            // Ensure the node is eligible
            guard let node = findHitNode(recognizer: recognizer, view: sceneView, recursively: true) else { return }
            selectedNode = node
            break
        case .changed:
            // Ensure there is a selected node
            guard let node = selectedNode else { return }
            
            // Get current pan location
            let location = recognizer.location(in: recognizer.view)
            let hitTestResults = sceneView.hitTest(location, types: ARHitTestResult.ResultType.existingPlane)
            guard let hitTestResult: ARHitTestResult = hitTestResults.first else { return }
            let worldPos = hitTestResult.worldTransform.columns.3

            // Move the node to current location
            let position = SCNVector3Make(worldPos.x, worldPos.y, worldPos.z)
            node.position = position
            break
        case .ended:
            // Clear the selected node
            selectedNode = nil
            break
        default:
            break
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

// MARK: - RPPreviewViewControllerDelegate
extension ViewController: RPPreviewViewControllerDelegate{
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

