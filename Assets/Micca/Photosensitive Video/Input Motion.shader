Shader "Micca/Photosensitive Input"
{
    Properties
    {
        _MainTex ("Input Video", 2D) = "black" {}
        _Mod1 ("Attack", float) = 1
        _Mod2 ("Release", float) = 1
        _Mod3 ("Cap/Sustain", float) = 1
        _Mod4 ("Test d", float) = 1
    }
    SubShader
    {
        Lighting Off
        Name "Motion Input"

        Pass {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            //todo: use the funny CRT trick to grab a self texture2D and use only texture2ds
            sampler2D _MainTex;

            float _Mod1, _Mod2, _Mod3, _Mod4;

            float4 frag(v2f_customrendertexture i) : COLOR {
                //setup
                float4 input = tex2Dlod(_MainTex,float4(i.localTexcoord.xy,0,0));
                float4 previous = tex2Dlod(_SelfTexture2D,float4(i.localTexcoord.xy,0,0));
                float accumulator = previous.a;

                accumulator = accumulator - _Mod2;

                accumulator += abs(max(input.r,max(input.g,input.b)) - max(previous.r,max(previous.g,previous.b))) * _Mod1;

                accumulator = clamp(accumulator,0,_Mod3);

                return float4(input.rgb,accumulator);
            }

            ENDCG
        }
    }
}
