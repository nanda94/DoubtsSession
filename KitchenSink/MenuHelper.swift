//
//  MenuHelper.swift
//  DoubtsSession
//
//  Created by Shreenandan Rajarathnam on 20/07/17.
//  Copyright © 2017 Shreenandan Rajarathnam. All rights reserved.
//

// Make the required changes!

// The width of the slide-out menu.
// Extent to which the user must pan before the menu's state changes.
// Constant used to tag a snapshot view for later retrieval.

// translationInView: User’s touch coordinates, viewBounds: Screen’s dimensions and direction: Slide-out menu's direction of movement.

    

// gestureState: The state of the pan gesture, progress: How far across the screen the user has panned, interactor: The UIPercentDrivenInteractiveTransition object that also serves as a state machine, triggerSegue: A closure that is called to initiate the transition. The closure will contain something like performSegueWithIdentifier().

import Foundation
import UIKit

enum Direction {
    case up
    case down
    case left
    case right
}

struct MenuHelper {
    
    static let menuWidth:CGFloat = 0.8
    
    static let percentThreshold:CGFloat = 0.3
    
    static let snapshotNumber = 12345
    
    static func calculateProgress(_ translationInView:CGPoint, viewBounds:CGRect, direction:Direction) -> CGFloat {
        let pointOnAxis:CGFloat
        let axisLength:CGFloat
        switch direction {
        case .up, .down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis:Float
        let positiveMovementOnAxisPercent:Float
        switch direction {
        case .right, .down: // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .up, .left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    static func mapGestureStateToInteractor(_ gestureState:UIGestureRecognizerState, progress:CGFloat, interactor: Interactor?, triggerSegue: () -> ()){
        guard let interactor = interactor else { return }
        switch gestureState {
        case .began:
            interactor.hasStarted = true
            triggerSegue()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
}
    

