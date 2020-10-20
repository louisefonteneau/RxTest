import UIKit
import RxSwift
import RxCocoa

enum Locale {
    case es
    case fr
    case en
    case it
}

let locale: Locale = .it

class ViewController: UIViewController {

    @IBOutlet weak var modalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var storylyTopViewLabel: UILabel!
    @IBOutlet weak var storylyTopView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var titleImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeScreenImageViewTitle: UIImageView!
    @IBOutlet weak var headerImageViewBackground: UIImageView!
    @IBOutlet weak var headerImageViewTitle: UIImageView!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeScreenImageViewBackground: UIImageView!

    enum Images {
        static let homeScreenEn = UIImage(named: "logo-anglais")
        static let homeScreenEs = UIImage(named: "logo-espagnol")
        static let homeScreenIt = UIImage(named: "logo-italien")
        static let homeScreenFr = UIImage(named: "logo-francais")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHomeScreen()
        configureContainerView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchAnimation()
    }

    private func setUpHomeScreen() {
        switch locale {
        case .es:
            homeScreenImageViewTitle.image = Images.homeScreenEs
        case .fr:
            homeScreenImageViewTitle.image = Images.homeScreenFr
        case .en:
            homeScreenImageViewTitle.image = Images.homeScreenEn
        case .it:
            homeScreenImageViewTitle.image = Images.homeScreenIt
        }
        headerImageViewTitle.alpha = 0
        headerImageViewBackground.alpha = 0
    }

    private func configureContainerView() {
        contentContainerView.layer.cornerRadius = 24
        storylyTopView.backgroundColor = UIColor(red: 231 / 255, green: 0 / 255, blue: 76 / 255, alpha: 1)
        storylyTopView.layer.cornerRadius = 29
        #warning("TODO: add translations")
        storylyTopViewLabel.text = "Is it already time?"
        storylyTopViewLabel.textColor = .white
    }

    private func launchAnimation() {
        titleTopConstraint.priority = UILayoutPriority(900)
        titleImageViewWidthConstraint.constant = 120
        modalTopConstraint.priority = UILayoutPriority(900)
        UIView.animate(withDuration: 0.4, delay: 2, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.4, options: [.curveEaseOut]) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.homeScreenImageViewBackground.alpha = 0
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.3, delay: 0,  usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: [.curveEaseOut]) { [weak self] in
                self?.headerImageViewTitle.alpha = 1
                self?.headerImageViewBackground.alpha = 1
            }
        }
    }
}

@IBDesignable
class CircularGradientView: UIView {

    @IBInspectable var insideColor: UIColor = UIColor(red: 17 / 255, green: 20 / 255, blue: 88 / 255, alpha: 1)
    @IBInspectable var outsideColor: UIColor = UIColor(red: 2 / 255, green: 4 / 255, blue: 61 / 255, alpha: 1)

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              let gradient = CGGradient(
                colorsSpace: nil,
                colors: [insideColor.cgColor, outsideColor.cgColor] as CFArray,
                locations: nil) else { return }

        let squaredRadius = pow(bounds.height / 2, 2) + pow(bounds.width / 2, 2)
        context.drawRadialGradient(
            gradient,
            startCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            startRadius: 0,
            endCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            endRadius: sqrt(squaredRadius),
            options: [.drawsAfterEndLocation])
    }
}
