using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

//micca

[DefaultExecutionOrder(2)]
[UdonBehaviourSyncMode(BehaviourSyncMode.None)]
public class PhotosensitiveVideoController : UdonSharpBehaviour
{
    public bool enable = false;
    public bool smoothAll = false;
    public RenderTexture inputMotion;
    public RenderTexture inputMotionBuffer;
    public Material inputMotionMat;
    public RenderTexture outputMotion;
    public RenderTexture outputMotionBuffer;
    public Material outputMotionMat;
    public RenderTexture texelVideoCRT;

    
    bool lastState = false;

    float updateTime = 0f;

    int globalTexPropertyId;


    void Start() {
        globalTexPropertyId = VRCShader.PropertyToID("_Udon_VideoTex");
        //idk why this doesn't fire right
        VRCShader.SetGlobalTexture(globalTexPropertyId, texelVideoCRT);
    }

    void Update() {
        if (enable) {
            VRCShader.SetGlobalTexture(globalTexPropertyId, outputMotion);
        } else {
            VRCShader.SetGlobalTexture(globalTexPropertyId, texelVideoCRT);
        }

        outputMotionMat.SetFloat("_Mod3",smoothAll?1f:0f);

        if (updateTime < Time.fixedTime) {
            if (lastState != enable) {
                if (!enable) {
                    inputMotion.Release();
                    inputMotionBuffer.Release();
                    outputMotion.Release();
                    outputMotionBuffer.Release();
                }
            }

            if (enable) {
                VRCGraphics.Blit(inputMotion,inputMotionBuffer);
                VRCGraphics.Blit(texelVideoCRT,inputMotion,inputMotionMat);
                VRCGraphics.Blit(outputMotion,outputMotionBuffer);
                VRCGraphics.Blit(inputMotion,outputMotion,outputMotionMat);
            }

            updateTime = Time.fixedTime + 0.0333f; //30 fpsish
            lastState = enable;
        }
    }
}
