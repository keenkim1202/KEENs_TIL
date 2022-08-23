extension UIView {
    enum ShadowLocation {
        case bottom
        case top
        case left
        case right
    }

    func addShadow(locations: [ShadowLocation], color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 0) {
      for location in locations {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -5, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 5, height: 0), color: color, opacity: opacity, radius: radius)
        }
      }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
