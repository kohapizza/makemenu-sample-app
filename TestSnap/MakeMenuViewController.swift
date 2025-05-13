//
//  MakeMenuViewController.swift
//  TestSnap
//
//  Created by 佐伯小遥 on 2025/05/13.
//

import UIKit

class MakeMenuViewController: UIViewController {
    // 受け取ったテキスト（食材たち）
    var receivedText: String!
    
    // 材料リスト
    var ingredientsArray: [String]!
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MakeMenuView.receivedText: \(receivedText ?? "")")

        if let ingredients = ingredientsArray {
            receivedText = ingredients.joined(separator: ",")
        }
        
        setmenuText()
    }
    
    
    
    func setmenuText() {
        Task {
            let text = await MachineLearningHelper.shared.fetchIdea(receivedText: receivedText)
            print("MakeMenu.text: \(text)")
            menuLabel.text = text
            activityIndicator.isHidden = true
            backButton.isHidden = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToFirstScreen(_ sender: UIButton) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialVC = storyboard.instantiateInitialViewController()

            window.rootViewController = initialVC
            window.makeKeyAndVisible()
        }
    }


}
