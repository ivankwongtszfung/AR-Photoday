//
//  PhotoGallery.swift
//  AR-Photoday
//
//  Created by Joker Lung on 8/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class PhotoGallery: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDropInteractionDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var image: UIImage! // a global var that stores image being shown on screen ready to share or edit
    var editMode = false // tap -> add sticker
    var imgView: UIImageView!
    
    var newImgWidth: CGFloat = 0.0
    var newImgHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var leftMost: CGFloat = 0.0
    var rightMost: CGFloat = 0.0
    var topMost: CGFloat = 0.0
    var bottomMost: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        self.showPhotoLibrary()
        scrollView.isUserInteractionEnabled = true


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
//        image = resizeImage(image: image)
        imgView = UIImageView(image: image)
        imgView.isUserInteractionEnabled = true
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        imgView.addGestureRecognizer(tapGesture)
        imgView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        
        // Get the width and height of the resized image
        viewWidth = imgView.bounds.size.width
        let imgWidth = (imgView.image?.size.width)!
        viewHeight = imgView.bounds.size.height
        let imgHeight = (imgView.image?.size.height)!
        let widthRatio = viewWidth / imgWidth;
        let heightRatio = viewHeight / imgHeight;
        let scale = min(widthRatio, heightRatio);
        newImgWidth = scale * imgWidth;
        newImgHeight = scale * imgHeight;
        leftMost = (viewWidth - newImgWidth) / 2
        rightMost = newImgWidth + leftMost
        topMost = (viewHeight - newImgHeight) / 2
        bottomMost = newImgHeight + topMost
        
        self.scrollView.addSubview(imgView)
        
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let size = image.size
        
        let widthRatio  = self.scrollView.frame.width  / size.width
        let heightRatio = self.scrollView.frame.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
// =================== Edit Function Start ===================

    @objc func tap(sender:UITapGestureRecognizer){
        if(editMode == true){
            if sender.state == .ended {
                var touchLocation: CGPoint = sender.location(in: sender.view) //this is the location within imageview
                let subImage = UIImageView(image: image)
                
                if(touchLocation.x > leftMost && touchLocation.x < rightMost && touchLocation.y > topMost && touchLocation.y < bottomMost){
                    DispatchQueue.main.async {
                        self.imgView.addSubview(subImage)
                        subImage.frame = CGRect(x: touchLocation.x, y: touchLocation.y, width: 30, height: 30)
                    }
                }
                
            }
        }
    }
// =================== Edit Function End ===================
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
}
