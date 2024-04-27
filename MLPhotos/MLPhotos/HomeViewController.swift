//
//  ViewController.swift
//  MLPhotos
//
//  Created by Abhinay Maurya on 27/04/24.
//

import UIKit
import Vision

class HomeViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    
    //MARK: Properties
    private let imagePicker = UIImagePickerController()
    private var viewModel: MLPImageDetectionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    //MARK: Private methods
    private func initialSetting() {
        let model = try? VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model)
        viewModel = MLPImageDetectionVM(coreModel: model)
        self.imagePicker.delegate = self
        self.imgview.isHidden = true
        self.imgview.layer.borderWidth = 2.0
        self.imgview.layer.borderColor = UIColor.blue.cgColor
        self.imgview.layer.cornerRadius = 10.0
        self.imgview.layer.masksToBounds = true
    }
    
    private func getPredictionFor(imageUrl: URL?) {
        guard let imageUrl else {
            return
        }
        
        viewModel?.getMostPredictedName(for: imageUrl,
                                        handler: { prediction in
            self.lblTitle.text = prediction?.capitalized
        })
    }
    
    //IBAction
    @IBAction func didClickOnSelectImage() {
        self.presentPhotoPickerController()
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoPickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imgview.image = nil
        self.lblTitle.text = nil
        self.imgview.isHidden = true
        
        if let url = info[.imageURL] as? URL {
            getPredictionFor(imageUrl: url)
            if let pickedImage = info[.originalImage] as? UIImage {
                self.imgview.image = pickedImage
                self.imgview.isHidden = false
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

