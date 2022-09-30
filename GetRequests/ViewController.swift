//
//  ViewController.swift
//  GetRequests
//
//  Created by Zhanna Rolich on 27.09.2022.
//
import Foundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.delegate = self
    }
    
    
    @IBAction func requestButton(_ sender: Any) {
        view.endEditing(true)
        getPosts()
    }
    
    func getPosts() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(idTextField.text!)")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            
            guard let data = data,
                  let dataString = String(data: data, encoding: .utf8),
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else { return }
            DispatchQueue.main.async {
                self.resultTextView.text = dataString
              }
            
        }
        task.resume()
        
    }
    
    
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap (){
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        idTextField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
