//
//  FormSelectorCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 23/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormSelectorCell: FormBaseCell {

    
    override open func configure() {
        super.configure()
        accessoryType = .disclosureIndicator
    }
    
    override open func update() {
        super.update()
        textLabel?.text = rowDescriptor.title

//        if let selectedValues = rowDescriptor.value as? [NSObject] {
        if let  _ = rowDescriptor.value as? [NSObject] {
        
            let title: String! = nil
//            for optionValue in rowDescriptor.options {
//                if find(selectedValues, optionValue) != nil {
//                    let optionTitle = rowDescriptor.titleForOptionValue(optionValue)
//                    if title != nil {
//                        title = title + ", \(optionTitle)"
//                    }
//                    else {
//                        title = optionTitle
//                    }
//                }
//            }
            
            detailTextLabel?.text = title
        }
    }
    
    override open class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        if let row = selectedRow as? FormSelectorCell {
            
            formViewController.view.endEditing(true)
            
            var selectorClass: UIViewController.Type!
            
            //if row.rowDescriptor.selectorControllerClass == nil { // fallback to default cell class
                selectorClass = FormOptionsSelectorController.self
            //}
            //else {
            //    selectorClass = row.rowDescriptor.selectorControllerClass as? UIViewController.Type
            //}
            
            if selectorClass != nil {
                let selectorController = selectorClass.init()
                if let formRowDescriptorViewController = selectorController as? FormSelector {
                    formRowDescriptorViewController.formCell = row
                    formViewController.navigationController?.pushViewController(selectorController, animated: true)
                }
                else {
                    fatalError("selectorControllerClass must conform to FormSelector protocol.")
                }
            }
        }
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
