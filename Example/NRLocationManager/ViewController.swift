//
//  ViewController.swift
//  NRLocationManager
//
//  Created by Naveen Rana on 02/19/2018.
//  Copyright (c) 2018  Naveen Rana. All rights reserved.
//

import UIKit
import NRLocationManager

class ViewController: UIViewController {
    
    //MARK: ------------------- Variables / Outlets  --------------------
    @IBOutlet weak var label: UILabel!
    //MARK: ------------------- ViewLifeCycle  --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ------------------- Custom Methods  --------------------
    
    func initializeView() {
        oneTimeLocationButtonPressed()
    }
    
    func updateLabel(string: String) {
        label.text = string
    }
    
    
    //MARK: ------------------- IBActions  --------------------
    @IBAction func oneTimeLocationButtonPressed() {
        updateLabel(string: "One Time Location ...")
        NRLocationManger.shared.fetchLocation(locationType: .onetime) { (location, error) in
            if error != nil {
                self.updateLabel(string: error.debugDescription)
                
            }
            else {
                self.updateLabel(string: "Location: \(location!.coordinate.latitude) , \(location!.coordinate.longitude)")
            }

        }
        
    }
    
    @IBAction func continousLocationButtonPressed(sender: UIButton) {
        updateLabel(string: "Continous Location ...")
        NRLocationManger.shared.fetchLocation(locationType: .continous) { (location, error) in
            if error != nil {
                self.updateLabel(string: error.debugDescription)
                
            }
            else {
                self.updateLabel(string: "Location: \(location!.coordinate.latitude) , \(location!.coordinate.longitude)")
            }
            
        }

    }
    
    @IBAction func significantLocationButtonPressed(sender: UIButton) {
        updateLabel(string: "Significant Location ...")
        NRLocationManger.shared.fetchLocation(locationType: .significant) { (location, error) in
            if error != nil {
                self.updateLabel(string: error.debugDescription)
                
            }
            else {
                self.updateLabel(string: "Location: \(location!.coordinate.latitude) , \(location!.coordinate.longitude)")
            }
            
        }
    }
}

