/*建立了一个功能完备带动画的 3D 场景。你需要打开 Assistant Editor (在菜单上依次点击 View | Assistant Editor | Show Assistant Editor)，3D 效果和动画将会被自动渲染。这不需要编译循环，而且任何的改动，比如改变颜色、几何形状、亮度等，都能实时反映出来。使用它能在一个交互例子中很好的记录 和介绍如何使用框架。
*/

import Cocoa
import XCPlayground
import PlaygroundSupport
import QuartzCore
import SceneKit

// Scene
let scene = SCNScene()
let objectsNode = SCNNode()
scene.rootNode.addChildNode(objectsNode)

// Ambient light
let ambientLight = SCNLight()
let ambientLightNode = SCNNode()
ambientLight.type = SCNLight.LightType.ambient
ambientLight.color = NSColor(deviceWhite:0.1, alpha:1.0)
ambientLightNode.light = ambientLight
scene.rootNode.addChildNode(ambientLightNode)

// Diffuse light
let diffuseLight = SCNLight()
let diffuseLightNode = SCNNode()
diffuseLight.type = SCNLight.LightType.omni;
diffuseLightNode.light = diffuseLight;
diffuseLightNode.position = SCNVector3(x:0, y:300, z:0);
scene.rootNode.addChildNode(diffuseLightNode)

// Torus
let torusReflectiveMaterial = SCNMaterial()
torusReflectiveMaterial.diffuse.contents = NSColor.blue
torusReflectiveMaterial.specular.contents = NSColor.white
torusReflectiveMaterial.shininess = 5.0

let torus = SCNTorus(ringRadius:60, pipeRadius:20)
let torusNode = SCNNode(geometry:torus)
torusNode.position = SCNVector3(x:-50, y:0, z:-100)
torus.materials = [torusReflectiveMaterial]
objectsNode.addChildNode(torusNode)

let animation = CAKeyframeAnimation(keyPath:"transform")
animation.values = [
    NSValue(caTransform3D:CATransform3DRotate(torusNode.transform, CGFloat((0.0 * M_PI) / 2.0), CGFloat(1.0), CGFloat(0.5), CGFloat(0.0))),
    NSValue(caTransform3D:CATransform3DRotate(torusNode.transform, CGFloat((1.0 * M_PI) / 2.0), CGFloat(1.0), CGFloat(0.5), CGFloat(0.0))),
    NSValue(caTransform3D:CATransform3DRotate(torusNode.transform, CGFloat((2.0 * M_PI) / 2.0), CGFloat(1.0), CGFloat(0.5), CGFloat(0.0))),
    NSValue(caTransform3D:CATransform3DRotate(torusNode.transform, CGFloat((3.0 * M_PI) / 2.0), CGFloat(1.0), CGFloat(0.5), CGFloat(0.0))),
    NSValue(caTransform3D:CATransform3DRotate(torusNode.transform, CGFloat((4.0 * M_PI) / 2.0), CGFloat(1.0), CGFloat(0.5), CGFloat(0.0)))]

animation.duration = 3.0
animation.repeatCount = 100000
torusNode.addAnimation(animation, forKey:"transform")

// Display
let sceneKitView = SCNView(frame:NSRect(x:0.0, y:0.0, width:400.0, height:400.0), options:nil)
sceneKitView.scene = scene
sceneKitView.backgroundColor = NSColor.red

XCPShowView(identifier: "SceneKit view", view: sceneKitView)

//PlaygroundPage.current.liveView


