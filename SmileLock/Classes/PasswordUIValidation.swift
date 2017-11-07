//
//  PasswordUIValidation.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

open class PasswordUIValidation<T>: PasswordInputCompleteProtocol {
    public typealias Failure    = () -> Void
    public typealias Success    = (T) -> Void
    public typealias Validation = (String) -> T?
    
    open var failure: Failure?
    open var success: Success?
    
    open var validation: Validation?
    
    open var view: PasswordContainerView!
    
    public init(in stackView: UIStackView, width: CGFloat? = nil, digit: Int) {
        view = PasswordContainerView.create(in: stackView, digit: digit)
        view.delegate = self
        guard let width = width else { return }
        view.width = width
    }
    
    open func resetUI() {
        view.clearInput()
    }
    
    //MARK: PasswordInputCompleteProtocol
    open func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        guard let model = self.validation?(input) else {
            passwordContainerView.wrongPassword()
            failure?()
            return
        }
        success?(model)
    }
    
    open func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {}

    open func onCancel(_ passwordContainerView: PasswordContainerView) {
    }
}
