import UIKit
import AVFoundation

struct Animator {
    
    func createHeart(_ startPoint: CGPoint, _ like: Bool) -> UIImageView {
        let heart = UIImageView.init(image: UIImage(named: like ? "like" : "dislike"))
        heart.tintColor = VotingColor.shared.hue(like)
        let frame = CGRect(origin: startPoint, size: CGSize(width: 20, height: 20))
        heart.layer.opacity = 0.0
        heart.frame = frame
        return heart
    }
    
    func animateHeart(_ heart: UIImageView, completion: @escaping () -> Void) {
        var startPoint = heart.center
        startPoint.x -= CGFloat.random(in: -10 ... 10)
        
        let endPoint = CGPoint(x: startPoint.x - CGFloat.random(in: -10 ... 10), y: startPoint.y - 100)
        
        let curvePoint1 = CGPoint(x: startPoint.x - CGFloat.random(in: -20 ... 20), y: startPoint.y - 50)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: curvePoint1)
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        anim.path = path.cgPath
        
        let fadeAnimation = CAKeyframeAnimation(keyPath:"opacity")
        fadeAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
        fadeAnimation.duration = 1
        fadeAnimation.keyTimes = [0, 1/8.0, 5/8.0, 1] as [NSNumber]
        fadeAnimation.values = [0.0, 1.0, 1.0, 0.0]
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        var animations = [CAAnimation]()
        animations.append(anim)
        animations.append(fadeAnimation)
        
        let group = CAAnimationGroup()
        group.duration = 1
        group.repeatCount = 1
        group.animations = animations
        
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        
        heart.layer.add(group, forKey: "heart")
        CATransaction.commit()
    }
}
