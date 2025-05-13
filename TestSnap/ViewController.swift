import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    var capturedImage: UIImage?  // 撮った画像を保持

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        // カメラが使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("カメラが使えません")
        }
    }

    
    // 撮影完了時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            capturedImage = image  // プロパティに保存
        }
        
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "showRetakeViewController", sender: nil)
        }
    }

    // キャンセル時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Segue の前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRetakeViewController",
           let destinationVC = segue.destination as? RetakeViewController {
            destinationVC.takenImage = capturedImage
        }
    }
}
