//
//  RetakeViewController.swift
//  TestSnap
//
//  Created by 佐伯小遥 on 2025/05/13.
//

import UIKit

class RetakeViewController: UIViewController {
    // 撮った写真を表示させるimageView
    @IBOutlet weak var imageView: UIImageView!
    
    // 外から受け取る画像用プロパティ
    var takenImage: UIImage?
    
    var recognizedObject: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 画像を表示
        if let image = takenImage {
            imageView.image = image
        }
    }
    
    @IBAction func extructionButtonTapped(_ sender: Any) {
        
        guard let image = takenImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        recognizeImage(imageData: imageData)
    }
   
    @IBAction func backboneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func recognizeImage(imageData: Data) {
        Task {
            let labels = await MachineLearningHelper.shared.analyzeImage(imageData: imageData)
            let isFood = await MachineLearningHelper.shared.checkFoodInImage(imageData: imageData)

            DispatchQueue.main.async {
                if isFood == "true" {
                    self.showResultViewController(with: labels)
                } else {
                    // 後で
                    //self.showErrorViewController()
                }
            }
        }
    }
    
    
    
    func showResultViewController(with foodstuffs: String) {
        DispatchQueue.main.async {
            guard let resultVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
                return
            }
            
            resultVC.foodstuffs = foodstuffs

            self.present(resultVC, animated: true, completion: nil)
        }
    }


}
