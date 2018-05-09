//
//  PhotoGallery.swift
//  AR-Photoday
//
//  Created by Joker Lung on 8/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class PhotoGallery: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    var image: UIImage! // a global var that stores image being shown on screen ready to share or edit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showPhotoLibrary()
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
        if image?.size != nil{
            let alert = UIAlertController(title: "Action", message: "", preferredStyle: .actionSheet)
            let cancelbutton = UIAlertAction(title: "Cancel", style: .cancel)
            let sharebutton = UIAlertAction(title: "Share", style: .default) { (_) in
                self.share()
            }
            let editbutton = UIAlertAction(title: "Edit", style: .default) { (_) in
                self.edit()
            }
            
            alert.addAction(cancelbutton)
            alert.addAction(sharebutton)
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
        print("edit")
    }
// =================== Option Function End ===================

}
