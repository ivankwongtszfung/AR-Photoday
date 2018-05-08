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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: nil)
    }
    
}
