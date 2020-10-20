//
//  ModalViewController.swift
//  RxTest
//
//  Created by Louise Fonteneau on 09.09.20.
//  Copyright © 2020 Louise Fonteneau. All rights reserved.
//

import Foundation
import Reusable

private class BundleEnforcer {}

extension Bundle {
    static var current: Bundle? {
        return Bundle(for: BundleEnforcer.self)
    }
}

final class ModalViewController: UIViewController, StoryboardBased {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bottomModalConstraint: NSLayoutConstraint!

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var modalView: UIView!

    private var viewTranslation = CGPoint(x: 0, y: 0)
    private var clearModal = false

    private lazy var animationTransition: ModalViewTransitionManager = {
        ModalViewTransitionManager(animationDuration: animationDuration)
    }()

    func toto(completion: (() -> Void)? = nil) {

    }

    var dismiss: () -> Void = {
        print("toto")
    }

    init() {
        super.init(nibName: String(describing: ModalViewController.self), bundle: .current)
        modalPresentationStyle = .custom
        transitioningDelegate = animationTransition
        toto(completion: dismiss)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .custom
        transitioningDelegate = animationTransition
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        separatorView.layer.cornerRadius = 3
        modalView.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius: 24)
    }

    private func setUpView() {
        separatorView.backgroundColor = UIColor(red: 0.87, green: 0.89, blue: 0.9, alpha: 1)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        bottomModalConstraint.constant = -modalView.frame.height
        let tapBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        backgroundView.addGestureRecognizer(tapBackgroundGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(animateModal(from:)))
        modalView.addGestureRecognizer(panGesture)
    }

    private func animate(with duration: TimeInterval,
                         options: UIView.AnimationOptions = [],
                         animations: @escaping () -> Void,
                         completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.78,
                       initialSpringVelocity: 0.8,
                       options: options,
                       animations: animations,
                       completion: completion)
    }

    @objc private func dismissModal() {
        dismiss(animated:true, completion: nil)
    }

//    @objc private func dismiss() {
//        hideContentView()
//        animate(with: 0.4, options: .curveEaseOut, animations: { [weak self] in
//            self?.view.layoutIfNeeded()
//            self?.backgroundView.alpha = 0
//        }) { [weak self] _ in
//            self?.dismiss(animated: false, completion: nil)
//        }
//    }

    @objc private func animateModal(from sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            if translation.y >= 0 {
                print(translation)
                viewTranslation = translation
                animate(with: 0.4, options: .curveEaseOut, animations: {
                    self.modalView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
        case .ended:
            if viewTranslation.y < modalView.frame.height / 4 {
                animate(with: 0.4, options: .curveEaseOut, animations: {
                    self.modalView.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension UIView {
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension ModalViewController: ModalViewPresentingProtocol {

    var animationDuration: TimeInterval {
        0.4
    }

    func showContentView() {
        bottomModalConstraint.constant = -20
    }

    func hideContentView() {
        bottomModalConstraint.constant = -modalView.frame.height
    }

    func showBackground() {
        backgroundView.alpha = 0.4
    }

    func hideBackground() {
        backgroundView.alpha = 0
    }
}
