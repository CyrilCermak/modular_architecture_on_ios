//
//  ISSButton.swift
//  ISSUIComponents
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import Combine

public class ISSButton: UIButton {
    public let tapped = PassthroughSubject<Void, Never>()
    
    public enum Style {
        case pink, blue
        
        var color: UIColor {
            switch self {
            case .pink: return UIColor.issPink
            case .blue: return UIColor.issBlue
            }
        }
    }
    
    public convenience init(title: String, style: Style) {
        self.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width-46, height: 46))
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = style.color
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        tapped.send(Void())
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
