////
//  MenuViewController.swift
//  DoubtsSession
//
//  Created by Shreenandan Rajarathnam on 18/07/17.
//  Copyright © 2017 Shreenandan Rajarathnam. All rights reserved.
//
//  MenuViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//
//  Copyright (c) 2016 Thorn Technologies LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class MenuViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var interactor:Interactor? = nil
    
    var menuActionDelegate:MenuActionDelegate? = nil
    
    let menuItems = ["Audio/Video Setup", "About DoubtsSession", "Provide Feedback","Logout"]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateuserNameLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        getUserInfo()
        //getUserImage()
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func getUserInfo() {
        // Retrieves the details for the authenticated user.
        SparkContext.sharedInstance.spark?.people.getMe() {[weak self] response in
            if let strongSelf = self {
                switch response.result {
                case .success(let person):
                    SparkContext.sharedInstance.selfInfo = person
                    strongSelf.updateuserNameLabel()
                case .failure:
                    SparkContext.sharedInstance.selfInfo = nil
                    strongSelf.updateuserNameLabel()
                }
            }
        }
    }
    
    /* FOLLOWING FUNCTION DOESN'T WORK AS EXPECTED, SHALL BE FIXED SOON!
     
     func getUserImage() {
        // Retrieves the details for the authenticated user.
        SparkContext.sharedInstance.spark?.people.getMe() {[weak self] response in
            if let strongSelf = self {
                switch response.result {
                case .success(let person):
                    SparkContext.sharedInstance.selfInfo = person
                    setImageFromURl(stringImageUrl: SparkContext.sharedInstance.selfInfo?.avatar!.asURL())
//                case .failure:
  //                  SparkContext.sharedInstance.selfInfo = nil
    //                strongSelf.updateuserImage()
                }
            }
        }
    }*/
    
    fileprivate func updateuserNameLabel() {
        userNameLabel.text = "\(SparkContext.sharedInstance.selfInfo?.displayName ?? "Welcome")"
    }
    
    /*func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                userImage.image = UIImage(data: data as Data)
            }
        }
    }*/
    
    func goBackToLogin() {
        dismiss(animated: true, completion: nil)
    }

    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        dismiss(animated: true){
            self.delay(seconds: 0.5){
                self.menuActionDelegate?.reopenMenu()
            }
        }
    }
    
}

extension MenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            menuActionDelegate?.openSegue("AVSetup", sender: nil)
        case 1:
            menuActionDelegate?.openSegue("About", sender: nil)
        case 2:
            menuActionDelegate?.openSegue("Feedback", sender: nil)
        case 3:
            menuActionDelegate?.logout()
            goBackToLogin()
        default:
            break
        }
    }
    
}
