Shader "Micca/Photosensitive Output"
{
    Properties
    {
        _MainTex ("Input Motion", 2D) = "black" {}
        _Mod1 ("Blur Value", float) = 1
        _Mod2 ("Threshold", float) = 1
        _Mod3 ("Just blur all of it", Range(0,1)) = 0
        _Mod4 ("Test d", float) = 1
    }
    SubShader
    {
        Lighting Off
        Name "Output"

        Pass {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            //todo: use the funny CRT trick to grab a self texture2D and use only texture2ds
            sampler2D _MainTex;

            float _Mod1, _Mod2, _Mod3, _Mod4;

            float _Udon_VideoBlurAll;

            float4 frag(v2f_customrendertexture i) : COLOR {
                //setup
                float4 input = tex2Dlod(_MainTex,float4(i.localTexcoord.xy,0,0));
                float4 previous = tex2D(_SelfTexture2D,float4(i.localTexcoord.xy,0,0));

                input = lerp(input,previous,lerp(0,_Mod1,saturate(input.a-_Mod2)));

                input = lerp(input,previous,clamp(_Udon_VideoBlurAll,0,.95));

                return input;
            }

            ENDCG
        }
    }
}
