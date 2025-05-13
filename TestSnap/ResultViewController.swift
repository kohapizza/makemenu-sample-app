//
//  ResultViewController.swift
//  TestSnap
//
//  Created by 佐伯小遥 on 2025/05/13.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var resultTextView: UITextView!
    
    var foodstuffs: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTextView.text = foodstuffs
        resultTextView.isEditable = false
        resultTextView.isScrollEnabled = true
        print("foodstuff:\(foodstuffs ?? "")")
       
    }
    
    // 戻るボタン
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // はい
    @IBAction func nextButtonTapped(for segue: UIStoryboardSegue, sender: Any?) {
        performSegue(withIdentifier: "showMakeMenuViewController", sender: self)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showEditViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditViewController",
           let editVC = segue.destination as? EditViewController {
            editVC.receivedText = resultTextView.text
        }
        if segue.identifier == "showMakeMenuViewController",
           let nextVC = segue.destination as? MakeMenuViewController {
            nextVC.receivedText = foodstuffs
        }
    }
}
