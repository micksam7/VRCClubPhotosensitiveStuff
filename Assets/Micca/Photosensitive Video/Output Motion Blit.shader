Shader "Micca/Photosensitive Output Blit"
{
    Properties
    {
        _MainTex ("Input Motion", 2D) = "black" {}
        _SelfTex ("Buffer Texture", 2D) = "black" {}
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
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            //todo: use only texture2ds
            sampler2D _MainTex, _SelfTex;

            float _Mod1, _Mod2, _Mod3, _Mod4;

            //float _Udon_VideoBlurAll;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv =  v.uv;

                return o;
            }

            float4 frag(v2f i) : COLOR {
                //setup
                float4 input = tex2Dlod(_MainTex,float4(i.uv.xy,0,0));
                float4 previous = tex2D( _SelfTex,float4(i.uv.xy,0,0));

                input = lerp(input,previous,lerp(0,_Mod1,saturate(input.a-_Mod2)));

                input = lerp(input,previous,clamp(_Mod3,0,.95));

                input.a = 1;

                return input;
            }

            ENDCG
        }
    }
}
