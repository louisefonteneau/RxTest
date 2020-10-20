import Foundation
import UIKit
import Reusable

final class CatalogPricesView: UIView, NibOwnerLoadable {

    @IBOutlet weak var stackView: UIStackView!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }

//    private func label(for model: LabelPrices) -> CZGUILabel {
//        let label = CZGUILabel()
//        switch model.style {
//        case .normal:
//            label.text(model.text).style(.paragraph).color(TextColor.foggy.uiColor).alignment(.center)
//        case .highlight:
//            label.text(model.text).style(.subhead1Bold).color(MainColor.primaryDarker.uiColor).alignment(.center)
//        case .striked:
//            label.text(model.text)
//                .style(.custom(weight: .regular,
//                               size: 17,
//                               lineHeight: 20,
//                               baselineOffset: -2))
//                .color(TextColor.foggy.uiColor)
//                .alignment(.center)
//                .strikethroughStyle(1)
//        }
//        return label
//    }

    func configure(with labelPrices: [String]) {
        let separator = NSAttributedString(string: " ")
        let mutableAttributedString = NSMutableAttributedString(string: "")
        labelPrices.enumerated().forEach { index, labelModel in
            let price = NSAttributedString(string: "24 euros", attributes: [
                .foregroundColor: UIColor.blue
            ])
            mutableAttributedString.append(price)
            if index < labelPrices.count {
                mutableAttributedString.append(separator)
            }
            let priceView = UIView()
//            let labelPrice = label(for: labelModel)
            let labelPrice = UILabel()
            labelPrice.text = labelModel
            priceView.addSubview(labelPrice)
            labelPrice.fitTo(other: priceView)
            stackView.addArrangedSubview(priceView)
        }
    }
}

extension UIView {
    func fitTo(other: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: other.topAnchor, constant: constant).isActive = true
        self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -constant).isActive = true
        self.leftAnchor.constraint(equalTo: other.leftAnchor, constant: constant).isActive = true
        self.rightAnchor.constraint(equalTo: other.rightAnchor, constant: -constant).isActive = true
    }
}
