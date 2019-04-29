//
//  TextViewController.swift
//  MLDemo
//
//  Created by Rahul Mane on 20/04/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import NaturalLanguage

class TextViewController: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txtInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    @IBAction func btnCheckClicked(_ sender: Any) {
        let sentimentPredictor = try? NLModel(mlModel: SpamDetector().model)
        self.lblResult.text =  sentimentPredictor?.predictedLabel(for: txtInput.text ?? "")
    }
    
}
