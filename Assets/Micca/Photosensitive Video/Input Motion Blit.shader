Shader "Micca/Photosensitive Input Blit"
{
    Properties
    {
        _MainTex ("Input Video", 2D) = "black" {}
        _SelfTex ("Buffer Texture", 2D) = "black" {}
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
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            //todo: use texture2d
            sampler2D _MainTex, _SelfTex;

            float _Mod1, _Mod2, _Mod3, _Mod4;

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
                float4 previous = tex2Dlod(_SelfTex,float4(i.uv.xy,0,0));
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
