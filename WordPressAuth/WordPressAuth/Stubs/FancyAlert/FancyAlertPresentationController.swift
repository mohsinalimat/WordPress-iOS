import UIKit
import WordPressUI


/// Presents a view controller with a dimming view behind that slowly fades in
/// as the presented view controller slides up.
///
class FancyAlertPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    private let dimmingView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(white: 0.0, alpha: UIKitConstants.alphaMid)
        $0.alpha = UIKitConstants.alphaZero
        return $0
    }(UIView())

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        containerView.addSubview(dimmingView)
        containerView.pinSubviewToAllEdges(dimmingView)

        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            dimmingView.alpha = UIKitConstants.alphaFull
            return
        }

        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = UIKitConstants.alphaFull
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = UIKitConstants.alphaZero
            return
        }

        coordinator.animate(alongsideTransition: {
            _ in
            self.dimmingView.alpha = UIKitConstants.alphaZero
        })
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard presented == self.presentedViewController,
            presenting == self.presentingViewController else {
                return nil
        }

        return self
    }
}
