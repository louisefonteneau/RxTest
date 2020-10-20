import UIKit

protocol ModalViewPresentingProtocol {
    func hideContentView()
    func showContentView()
    func showBackground()
    func hideBackground()

    var view: UIView! { get set }
    var animationDuration: TimeInterval { get }
}

class ModalViewTransitionManager: NSObject {

    private let animationDuration: TimeInterval
    var transitionMode: TransitionMode = .present

    enum TransitionMode {
        case present, dismiss
    }

    init(animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }

    private func handlePresent(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .to),
            let modalViewController = presentedViewController as? ModalViewPresentingProtocol else {
                return
        }
        let containerView = transitionContext.containerView

        [presentedViewController].forEach {
            containerView.addSubview($0.view)
        }

        modalViewController.hideContentView()
        modalViewController.hideBackground()
        modalViewController.view.layoutIfNeeded()
        modalViewController.showContentView()
        UIView.animate(withDuration: animationDuration, delay: 0,
                       usingSpringWithDamping: 0.78,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        modalViewController.showBackground()
                        modalViewController.view.layoutIfNeeded()
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }

    private func handleDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .from),
            let modalViewController = presentedViewController as? ModalViewPresentingProtocol else {
                return
        }
        modalViewController.hideContentView()
        UIView.animate(withDuration: animationDuration, delay: 0,
                       usingSpringWithDamping: 0.78,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        modalViewController.hideBackground()
                        modalViewController.view.layoutIfNeeded()
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

extension ModalViewTransitionManager: UIViewControllerAnimatedTransitioning {

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionMode {
        case .present:
            handlePresent(using: transitionContext)
        case .dismiss:
            handleDismiss(using: transitionContext)
        }
    }
}

extension ModalViewTransitionManager : UIViewControllerTransitioningDelegate {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionMode = .present
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionMode = .dismiss
        return self
    }
}
