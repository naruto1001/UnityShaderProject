﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DiffuseHalfLambertShader"
{
    Properties{
        _Diffuse ("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader {
        Pass {
            Tags { "LightModel" = "ForwardBase" }

            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc" 

            fixed4 _Diffuse;

            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            }; 

            struct v2f{
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0; 
            }; 

            v2f vert(a2v i){
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.worldNormal = mul(i.normal, (float3x3)unity_WorldToObject);
                return o;
            }

            fixed4 frag(v2f o) : SV_Target{
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 worldNormal = normalize(o.worldNormal);
                float3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed halfLambert = dot(worldNormal, worldLight) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
                fixed3 color = ambient + diffuse;
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
