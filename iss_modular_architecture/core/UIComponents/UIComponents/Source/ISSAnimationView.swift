//
//  AnimationView.swift
//  ISSUIComponents
//
//  Created by Cyril Cermak on 14.02.21.
//

import Foundation
import Lottie
import SnapKit

public protocol AnimationLoadable {
    var name: String { get }
    var bundle: Bundle { get }
}

public struct Animation: AnimationLoadable {
    public var name: String
    public var bundle: Bundle
    
    public init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }
}

public class ISSAnimationView: UIView {
    
    private lazy var lottieView: Lottie.AnimationView = {
        let lottieView = Lottie.AnimationView(frame: self.frame)
        return lottieView
    }()
    
    public convenience init(animation: Animation) {
        self.init(frame: .zero)
        lottieView.animation = Lottie.Animation.named(animation.name,
                                                      bundle: animation.bundle)!
        lottieView.play()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lottieView)
        lottieView.loopMode = .loop
        lottieView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
