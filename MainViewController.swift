//
//  MainViewController.swift
//  DoubtsSession
//
//  Created by Shreenandan Rajarathnam on 18/07/17.
//  Copyright © 2017 Shreenandan Rajarathnam. All rights reserved.
//

import UIKit

protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func logout()
    func reopenMenu()
}

class MainViewController: UIViewController {
    
    let interactor = Interactor()
    
    @IBAction func openMenu(_ sender: AnyObject) {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    @IBAction func edgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "openMenu", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuActionDelegate = self
        }
    }
    
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension MainViewController : MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?) {
        dismiss(animated: true){
            self.performSegue(withIdentifier: segueName, sender: sender)
        }
    }
    
    /*func logout() {
        SparkContext.sharedInstance.deinitSpark()
        _ = navigationController?.popToRootViewController(animated: true)
        
    }*/
    
    func logout() {
     SparkContext.sharedInstance.deinitSpark()
     _ = navigationController?.popViewController(animated: true)
     
     }
    
    /*func logout()
    {
        let LoginViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController

        SparkContext.sharedInstance.deinitSpark()
        _ = /*navigationController?.pushViewController(LoginViewControllerObj!, animated: true)*/self.present(LoginViewControllerObj!, animated: true, completion: nil)
     }*/
    
    func reopenMenu(){
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
}
