# AntiShake shaders for Unity
These are a set of shaders that have less visual error when rendering an object at a large distance away from the origin point.  
Included in this repository are modified Unity Standard shaders (Standard, Standard Specular, Autodesk Interactive), and [SaccFlight shaders](https://github.com/Sacchan-VRC/SaccFlightAndVehicles/tree/master/Shaders)  
Unity Standard shaders and SaccFlight are MIT licensed, thus this repository is also MIT licensed, with the exception of the Standard Shader Editor which is [Unity Reference Only License](https://unity3d.com/legal/licenses/Unity_Reference_Only_License)

[Latest Download](https://github.com/BlueAmulet/AntiShake/releases/latest/download/AntiShake-Shaders.unitypackage)

## How?

By applying the object's position later in the vertex shader, at the cost of one more mul(mat4x4, float4) or 4 more instructions, the visual readability of the object increases. This does not eliminate shaking, but helps elements such as text remain readable.

![](/example.png)

[Marble Bust 01](https://polyhaven.com/a/marble_bust_01) used from [Poly Haven](https://polyhaven.com/) licensed [CC0](https://creativecommons.org/public-domain/cc0/)
