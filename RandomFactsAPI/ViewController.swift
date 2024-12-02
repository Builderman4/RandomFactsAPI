//
//  ViewController.swift
//  RandomFactsAPI
//
//  Created by Ibrahim Syed on 2024-11-25.
//

import UIKit

class ViewController: UIViewController {

 @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData() // This is to fetch an inital fact on launch
    }

    @IBAction func fetchNewFact(_ sender: UIButton) {
        fetchData() 
    }

    func fetchData() {
        let apiUrlString = "https://uselessfacts.jsph.pl/random.json?language=en"
        guard let url = URL(string: apiUrlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.updateTextView(text: "Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.updateTextView(text: "Invalid response from server")
                return
            }

            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let fact = jsonObject["text"] as? String {
                        self.updateTextView(text: fact)
                    } else {
                        self.updateTextView(text: "Error parsing fact")
                    }
                } catch {
                    self.updateTextView(text: "Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }

    func updateTextView(text: String) {
        DispatchQueue.main.async {
            self.outputTextView.text = text
        }
    }
}
