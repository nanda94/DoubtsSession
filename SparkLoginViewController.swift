//
//  SparkLoginViewController.swift
//  DoubtsSession
//
//  Created by Shreenandan Rajarathnam on 18/07/17.
//  Copyright © 2017 Shreenandan Rajarathnam. All rights reserved.
//

import UIKit
import SparkSDK

class SparkLoginViewController: UIViewController
{
    
    private var oauthenticator: OAuthAuthenticator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SparkContext.initSparkForSparkIdLogin()
        oauthenticator = SparkContext.sharedInstance.spark?.authenticator as! OAuthAuthenticator
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauthenticator.authorized {
            showApplicationHome()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Login Handling
    
    @IBAction func performLogin(_ sender: UIButton)
    {
        oauthenticator.authorize(parentViewController: self) { [weak self] success in
            if success
            {
                print("Spark ID Login successful!")
            }
            else
            {
                if let strongSelf = self
                {
                    strongSelf.showLoginFailAlert()
                }
                
            }
        }
        
    }
    
    private func showApplicationHome()
    {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func showLoginFailAlert()
    {
        let alert = UIAlertController(title: "Alert", message: "ERROR: Spark login failed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
