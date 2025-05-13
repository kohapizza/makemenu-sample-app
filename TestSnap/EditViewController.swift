//
//  EditViewController.swift
//  TestSnap
//
//  Created by 佐伯小遥 on 2025/05/13.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var receivedText: String?
    var ingredientsArray: [String] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if let text = receivedText {
            ingredientsArray = text.components(separatedBy: ",")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showMakeMenuViewController", sender: self)
    }
    
    @IBAction func addIngredient(_ sender: UIButton) {
        showEditAlert(isNew: true, index: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMakeMenuViewController",
           let doneVC = segue.destination as? MakeMenuViewController {
            doneVC.ingredientsArray = ingredientsArray
        }
    }
    

}

extension EditViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredientsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "消去") { (action, view, completionHandler) in
            self.ingredientsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditAlert(isNew: false, index: indexPath.row)
    }
    
    func showEditAlert(isNew: Bool, index: Int?) {
        let alert = UIAlertController(title: isNew ? "食材を追加" : "食材を編集", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            if !isNew, let index = index {
                textField.text = self.ingredientsArray[index]
            }
        }
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                if isNew {
                    self.ingredientsArray.append(text)
                } else if let index = index {
                    self.ingredientsArray[index] = text
                }
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
