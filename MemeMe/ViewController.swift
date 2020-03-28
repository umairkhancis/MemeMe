//
//  ViewController.swift
//  MemeMe
//
//  Created by Umair Khan on 28/03/2020.
//  Copyright © 2020 NoorifyTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet private var albumButton: UIBarButtonItem!
    @IBOutlet private var cameraButton: UIBarButtonItem!
    @IBOutlet private var topTextField: UITextField!
    @IBOutlet private var bottomTextField: UITextField!
    @IBOutlet private var memeImageView: UIImageView!
    @IBOutlet private var shareButton: UIButton!
    private let memeTextFieldDelegate = MemeTextFieldTextFieldDelegate()
    private var memedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self.memeTextFieldDelegate
        self.bottomTextField.delegate = self.memeTextFieldDelegate
        
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareButton.isEnabled = memeImageView.image != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func onPickPhotoClicked(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onCameraClicked(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onShareButtonClicked(_ sender: Any) {
        self.memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: {
            self.saveMeme()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        
        memeImageView.image = selectedImage
        
        shareButton.isEnabled = memeImageView.image != nil
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    private func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar

        return memedImage
    }
    
    func saveMeme() {
        let memedImage = self.memedImage!
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
    }
}

