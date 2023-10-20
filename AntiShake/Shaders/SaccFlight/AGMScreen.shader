// Copyright (c) 2021 Sacchan-VRC. MIT license
// Modified by BlueAmulet to use UnityObjectToClipPosAlt

Shader "AntiShake/SF-1/AGMScreen" 
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
			#include "../AntiShake.cginc"

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
                o.vertex = UnityObjectToClipPosAlt(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float col = tex2D(_MainTex, i.uv).b;
                return col;
            }
            ENDCG
        }
    }
}
