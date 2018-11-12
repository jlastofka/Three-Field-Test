//
//  ViewController.swift
//  Speeds and Feeds
//
//  Created by Jeff Lastofka on 10 Oct 2018
//  Copyright © 2018 Jeff Lastofka. All rights reserved.
//

import UIKit

// UITextFieldDelegate is added for closing the keyboard
class ViewController: UIViewController, UITextFieldDelegate {
    
    var sfpm = 0.0, dia = 1.0, rpm = 0.0
    var ipm = 0.0, ipr = 0.0
    var count = 0
    var feed = 0.0
    var milling = true      // true = milling, false = turning

    @IBOutlet var materials: [UIButton]!
    
    @IBOutlet weak var selectedMaterial: UILabel!
    
    @IBOutlet weak var sfpmValue: UITextField!
    
    @IBOutlet weak var diaValue: UITextField!
    
    @IBOutlet weak var rpmValue: UITextField!
    
    @IBOutlet weak var ipmValue: UITextField!
    
    @IBOutlet weak var teethValue: UITextField!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var feedPerTooth: UITextField!

    @IBOutlet weak var millingTurning: UISegmentedControl!
    
    // this is for closing the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // raise view frame above keyboard while editing
    @objc func keyboardWillChange(notification:Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func update(){      // updates all fields after a change
        if selectedMaterial.text == "Aluminum" {
            sfpm = milling ? 150.0 : 550.0
        } else if selectedMaterial.text == "Steel" {
            sfpm = milling ? 80.0 : 150.0
        } else if selectedMaterial.text == "Brass" {
            sfpm = milling ? 150.0 : 325.0
        } else if selectedMaterial.text == "Custom" {
            sfpm = Double(sfpmValue.text!)!
        } else {
            sfpm = 1.0      // this would be an obvious error output
        }
        sfpmValue.text = String(Int(sfpm))
        dia=Double(diaValue.text!)!
        rpm = 3.82 * sfpm / dia
        rpmValue.text = String(Int(rpm))
        teethValue.text = String(Int(stepper.value))
        feed = Double(feedPerTooth.text!)!
        ipmValue.text = String((feed * rpm * stepper.value*10).rounded()/10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.diaValue.delegate = self       // this is for closing the keyboard
        self.feedPerTooth.delegate = self   // this is for closing the keyboard
        self.sfpmValue.delegate = self   // this is for closing the keyboard

        // listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        selectedMaterial.text = "Aluminum"
        diaValue.text = "0.5"
        feedPerTooth.text = String(0.005)
        update()
    }
    
    deinit {
        // stop listening for keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @IBAction func selectMaterial(_ sender: UIButton) {
        materials.forEach { (button) in
            button.isHidden = !button.isHidden
        }
        millingTurning.isHidden = !millingTurning.isHidden
    }
    
    @IBAction func aluminumChosen(_ sender: UIButton) {
        materials.forEach { (button) in
            button.isHidden = true
        }
        selectedMaterial.text = "Aluminum"
        update()
        millingTurning.isHidden = !millingTurning.isHidden
    }
    
    @IBAction func steelChosen(_ sender: UIButton) {
        materials.forEach { (button) in
            button.isHidden = true
        }
        selectedMaterial.text = "Steel"
        update()
        millingTurning.isHidden = !millingTurning.isHidden
    }
    
    @IBAction func brassChosen(_ sender: UIButton) {
        materials.forEach { (button) in
            button.isHidden = true
        }
        selectedMaterial.text = "Brass"
        update()
        millingTurning.isHidden = !millingTurning.isHidden
    }
    
    
    @IBAction func customChosen(_ sender: UIButton) {
        materials.forEach { (button) in
            button.isHidden = true
        }
        selectedMaterial.text = "Custom"
        update()
        millingTurning.isHidden = !millingTurning.isHidden
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        teethValue.text = String(Int(stepper.value))
        update()
    }
    
    @IBAction func diaValueChanged(_ sender: UITextField) {
        resignFirstResponder()          // close keyboard
        update()
    }
    
    @IBAction func sfpmValueChanged(_ sender: UITextField) {
        resignFirstResponder()          // close keyboard
        update()
    }
    
   
    @IBAction func feedPerToothChanged(_ sender: UITextField) {
        resignFirstResponder()          // close keyboard
        update()
    }
    
    @IBAction func millingTurningChanged(_ sender: UISegmentedControl) {
        if millingTurning.selectedSegmentIndex == 0 {
            milling = true
        } else {
            milling = false
        }
        update()
    }
}
