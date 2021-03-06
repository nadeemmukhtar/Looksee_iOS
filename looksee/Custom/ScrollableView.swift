//
//  ScrollableView.swift
//  looksee
//
//  Created by Justin Spraggins on 2/18/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

typealias OnEnd = ((Double) -> Void)?

struct ScrollableView<Content: View>: UIViewControllerRepresentable {
    
    var action: OnEnd
    
    func OnEnded(perform action: OnEnd) -> Self {
      var copy = self
      copy.action = action
      return copy
    }

    // MARK: - Type
    typealias UIViewControllerType = UIScrollViewController<Content>

    // MARK: - Properties
    var offset: Binding<CGPoint>
    var animationDuration: TimeInterval
    var content: () -> Content
    var showsScrollIndicator: Bool
    var axis: Axis

    // MARK: - Init
    init(_ offset: Binding<CGPoint>, animationDuration: TimeInterval, action: OnEnd, showsScrollIndicator: Bool = false, axis: Axis = .vertical, @ViewBuilder content: @escaping () -> Content) {
        self.offset = offset
        self.animationDuration = animationDuration
        self.action = action
        self.content = content
        self.showsScrollIndicator = showsScrollIndicator
        self.axis = axis
    }

    // MARK: - Updates
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {

        let scrollViewController = UIScrollViewController(action: self.action, rootView: self.content(), offset: self.offset, axis: self.axis)
        scrollViewController.scrollView.showsVerticalScrollIndicator = self.showsScrollIndicator
        scrollViewController.scrollView.showsHorizontalScrollIndicator = self.showsScrollIndicator

        return scrollViewController
    }

    func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
        viewController.updateContent(self.content)

        let duration: TimeInterval = self.duration(viewController)
        guard duration != .zero else {
            viewController.scrollView.contentOffset = self.offset.wrappedValue
            return
        }

        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: {
            viewController.scrollView.contentOffset = self.offset.wrappedValue
        }, completion: nil)
    }

    //Calculate animation speed
    private func duration(_ viewController: UIViewControllerType) -> TimeInterval {

        var diff: CGFloat = 0

        switch axis {
            case .horizontal:
                diff = abs(viewController.scrollView.contentOffset.x - self.offset.wrappedValue.x)
            default:
                diff = abs(viewController.scrollView.contentOffset.y - self.offset.wrappedValue.y)
        }

        if diff == 0 {
            return .zero
        }

        let percentageMoved = diff / UIScreen.main.bounds.height

        return self.animationDuration * min(max(TimeInterval(percentageMoved), 0.25), 1)
    }
}

final class UIScrollViewController<Content: View> : UIViewController, UIScrollViewDelegate, ObservableObject {
    
    var action: OnEnd
    
    func OnEnded(perform action: OnEnd) -> Self {
      var copy = self
      copy.action = action
      return copy
    }

    // MARK: - Properties
    var offset: Binding<CGPoint>
    let hostingController: UIHostingController<Content>
    private let axis: Axis
    lazy var scrollView: UIScrollView = {

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear

        return scrollView
    }()

    // MARK: - Init
    init(action: OnEnd, rootView: Content, offset: Binding<CGPoint>, axis: Axis) {
        self.action = action
        self.offset = offset
        self.hostingController = UIHostingController<Content>(rootView: rootView)
        self.hostingController.view.backgroundColor = .clear
        self.axis = axis
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Update
    func updateContent(_ content: () -> Content) {

        self.hostingController.rootView = content()
        self.scrollView.addSubview(self.hostingController.view)

        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize

        switch axis {
            case .vertical:
                contentSize.width = self.scrollView.frame.width
            case .horizontal:
                contentSize.height = self.scrollView.frame.height
        }

        self.hostingController.view.frame.size = contentSize
        self.scrollView.contentSize = contentSize
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view.addSubview(self.scrollView)
        self.createConstraints()
        self.view.layoutIfNeeded()
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.offset.wrappedValue = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.y
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            // swipes from top to bottom of screen -> down
            if let action = self.action { action(Double(value)) }
            
        } else {
            // swipes from bottom to top of screen -> up
        }
    }

    // MARK: - Constraints
    fileprivate func createConstraints() {

        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
