//
//  PhotoGallery.swift
//  AR-Photoday
//
//  Created by Joker Lung on 8/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class PhotoGallery: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDropInteractionDelegate {

    @IBOutlet weak var imgView: UIImageView!
    var image: UIImage! // a global var that stores image being shown on screen ready to share or edit
    var editMode = false // tap -> add sticker

    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showPhotoLibrary()
//        imgView.clipsToBounds = true
//        imgView.isMultipleTouchEnabled = false
        imgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        imgView.addGestureRecognizer(tapGesture)

        let optionButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(option))
        self.navigationItem.rightBarButtonItem = optionButton
    }

// =================== Pick Image Start ===================
    @objc func showPhotoLibrary(){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: nil)
    }
// =================== Pick Image End ===================

// =================== Option Function Start ===================
    @objc func option(){
        if (image?.size != nil){
            let alert = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
            let cancelbutton = UIAlertAction(title: "Cancel", style: .cancel)
            let sharebutton = UIAlertAction(title: "Share", style: .default) { (_) in
                self.share()
            }
            let editbutton = UIAlertAction(title: "Edit", style: .default) { (_) in
                self.edit()
            }
            alert.addAction(cancelbutton)
            alert.addAction(sharebutton)
            alert.addAction(editbutton)
            present(alert,animated: true,completion: nil)
        }else{
            self.showPhotoLibrary()
        }
    }
    
    func share(){
        let shareImage = image
        let activityViewController = UIActivityViewController(activityItems: [shareImage!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func edit(){
        editMode = true
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishEdit))
        self.navigationItem.rightBarButtonItem = donebutton
    }
    
    @objc func finishEdit(){
        let optionButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(option))
        self.navigationItem.rightBarButtonItem = optionButton
        editMode = false
    }
// =================== Option Function End ===================
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            let touch = touches.first
//            if let point = touch?.location(in: imgView){
//                startPoint = point
//            }
//            path.move(to: startPoint)
//            path.addLine(to: touchPoint)
//            startPoint = touchPoint
//            draw()
//
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//            let touch = touches.first
//            if let point = touch?.location(in: imgView){
//                touchPoint = point
//            }
//
//    }
//
//    func draw(){
//        let strokeLayer = CAShapeLayer()
//        strokeLayer.fillColor = nil
//        strokeLayer.lineWidth = 5
//        strokeLayer.strokeColor = UIColor.black.cgColor
//        strokeLayer.path = path.cgPath
//        imgView.layer.addSublayer(strokeLayer)
//        imgView.setNeedsLayout()
//    }
    
    @objc func tap(sender:UITapGestureRecognizer){
        if(editMode == true){
            if sender.state == .ended {
                var touchLocation: CGPoint = sender.location(in: sender.view) //this is the location within imageview
                let subImage = UIImageView(image: image)
                
                DispatchQueue.main.async {
                    self.imgView.addSubview(subImage)
                    subImage.frame = CGRect(x: touchLocation.x, y: touchLocation.y, width: 30, height: 30)
                }
            }
        }
    }
    
}
