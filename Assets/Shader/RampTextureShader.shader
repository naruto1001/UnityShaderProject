// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RampTextureShader"
{
    Properties{
        _MainColor ("MainColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _RampTex ("RampTex", 2D) = "white"{}
        _Specular ("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
        _Gloss ("Gloss", Range(8.0, 256.0)) = 20
    }

    SubShader {
        Pass{
            Tags { "LightModel" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc" 

            sampler2D _RampTex;
            float4 _RampTex_ST;
            fixed4 _MainColor;
            fixed4 _Specular;
            float _Gloss;

            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0; 
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0; 
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            }; 

            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = mul((float3x3)unity_ObjectToWorld, v.normal);
                o.worldPos = mul((float3x3)unity_ObjectToWorld, v.vertex);
                o.uv = v.texcoord * _RampTex_ST.xy + _RampTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target{
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 worldNormal = normalize(i.worldNormal);

                fixed halfLambert = 0.5 * dot(worldNormal, worldLightDir) + 0.5;
                fixed3 diffuseColor = tex2D(_RampTex, fixed2(halfLambert, halfLambert)).xyz * _MainColor.xyz;
                fixed3 diffuse = diffuseColor * _LightColor0.rgb;

                fixed3 halfDir = normalize(worldLightDir + worldViewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);

                return fixed4(ambient + diffuse + specular, 1.0);
            }

            ENDCG
        }
    }
}
