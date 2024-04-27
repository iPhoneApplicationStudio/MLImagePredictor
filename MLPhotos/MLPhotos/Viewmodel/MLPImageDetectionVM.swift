//
//  MLPImageDetectionVM.swift
//  MLPhotos
//
//  Created by Abhinay Maurya on 27/04/24.
//

import Foundation
import CoreML
import Vision

protocol MLPImageDetectionProtocol: AnyObject {
    func getMostPredictedName(for url: URL?,
                              handler: @escaping (String?) -> Void)
}

class MLPImageDetectionVM: MLPImageDetectionProtocol {
    private let coreModel: VNCoreMLModel?
    
    init(coreModel: VNCoreMLModel?) {
        self.coreModel = coreModel
    }
    
    func getMostPredictedName(for url: URL?,
                              handler: @escaping (String?) -> Void) {
        guard let coreModel,
              let url else {
            handler(nil)
            return
        }
        
        let imageHandler = VNImageRequestHandler(url: url)
        let request = VNCoreMLRequest(model: coreModel) { request, error in
            var identifier = ""
            var confidence: VNConfidence = 0
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            
            for result in results {
                if result.confidence > confidence {
                    identifier = result.identifier
                    confidence = result.confidence
                }
            }
            
            handler(identifier)
        }
        
        do {
            try imageHandler.perform([request])
        } catch {
            handler(nil)
        }
    }
}
