/*

Copyright (c) 2014 Vijay Kauvangal <vappflakes@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

This code is written based upon inspiration from RayWenderlich Articles
www.raywenderlich.com

*/

import UIKit

class SlidingMenuViewController: UIViewController {
    
    var leftViewController:UIViewController?
    var mainViewController:UIViewController?
    var offSet:CGFloat = 50.0
    private var _scrollView:UIScrollView?
    private var _firstTime:Bool = true
    
  

    override func viewDidLoad() {
        setupScrollView()
        setupViewController()
        self.view.backgroundColor = UIColor.redColor()
        self._firstTime=true

    }
        
    func setupScrollView(){
        _scrollView = UIScrollView(frame: CGRectZero)
        _scrollView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        _scrollView?.pagingEnabled = true
        self.view.addSubview(_scrollView!)

        let viewsDictionary = ["scrollView":self._scrollView!]
        let horizontalConstraints:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views:viewsDictionary)

  
        self.view.addConstraints(horizontalConstraints)
        
        let verticalConstraints:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil,views:viewsDictionary)
        self.view.addConstraints(verticalConstraints)
        
    }
    
    func setupViewController(){
        self.addViewController(self.leftViewController!);
        self.addViewController(self.mainViewController!);
        let viewsDictionary:[String:AnyObject!] = ["leftView":self.leftViewController?.view,"mainView":self.mainViewController?.view,"outerView":self.view];
        let horizontalConstraints:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("|[leftView][mainView(==outerView)]|", options: NSLayoutFormatOptions(0), metrics: nil, views:viewsDictionary)
        

         self.view.addConstraints(horizontalConstraints)
        
        let leftViewConstraint = NSLayoutConstraint(item:self.leftViewController!.view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant:-self.offSet)
        
        self.view.addConstraint(leftViewConstraint);
        
        let leftViewVerticalConstraints:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("V:|[leftView(==outerView)]|", options: NSLayoutFormatOptions(0), metrics: nil, views:viewsDictionary)
        self.view.addConstraints(leftViewVerticalConstraints)
        
        let mainViewVerticalConstraints:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainView(==outerView)]|", options: NSLayoutFormatOptions(0), metrics: nil, views:viewsDictionary)
        self.view.addConstraints(mainViewVerticalConstraints)
    }
    
    func addViewController(viewController:UIViewController){
        viewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        _scrollView?.addSubview(viewController.view)
        self.addChildViewController(viewController);
        viewController.didMoveToParentViewController(self);
    }
    
    func isMenuOpen() -> Bool{
        let contentOffSet = self._scrollView?.contentOffset
        return (contentOffSet?.x == 0)
    }
    
    func closeMenu(animated:Bool){
        var contentOffSet = self._scrollView?.contentOffset
        contentOffSet?.x = CGRectGetWidth(self.view.bounds) - self.offSet
        self._scrollView?.setContentOffset(contentOffSet!, animated: true)
    }
    
    func openMenu(animated:Bool) {
        self._scrollView?.setContentOffset(CGPointZero, animated: true)
    }
    
    func toggleMenu() {
        if self.isMenuOpen() {
            self.closeMenu(true)
        }else {
            self.openMenu(true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self._firstTime {
            self._firstTime = false
            self.closeMenu(false)
        }
    }
}

