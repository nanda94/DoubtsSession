//
//  MenuTableViewController.swift
//  DoubtsSession
//
//  Created by Shreenandan Rajarathnam on 18/07/17.
//  Copyright © 2017 Shreenandan Rajarathnam. All rights reserved.
//

/*import UIKit

class SlideoutMenuViewController : UIViewController {
    
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/

    var interactor:Interactor? = nil
    var menuActionDelegate:MenuActionDelegate? = nil
    
//    let storyboard: UIStoryboard = UIStoryboard.init(name: "StoryboardName", bundle: nil)
//    let firstViewController: MainViewController = storyboard.instantiateViewControllerWithIdentifier("StoryboardIdentifier") as! MainViewController
//    var mainObj : MainViewController! = MainViewController()
    

    
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
    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    @IBAction func callShowAVSetup(_ sender: UIButton) {
        menuActionDelegate?.reopenMenu()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        dismiss(animated: true){
            self.delay(seconds: 0.5){
                self.menuActionDelegate?.reopenMenu()
            }
        }
    }
    
}*/
