// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SingleTextureShader"
{
    Properties{
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Specular ("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
        _MianTex ("Main Texture", 2D) = "white"{}
        _Gloss ("Gloss", Range(8.0, 256.0)) = 20.0 
    }
    SubShader {
        Pass {
            Tags { "LightModel" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 

            #include "Lighting.cginc"

            fixed4 _Color;
            fixed4 _Specular;
            float _Gloss;
            sampler2D _MianTex;
            float4 _MianTex_ST; 

            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0; 
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2; 
            };  

            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = mul((float3x3)unity_ObjectToWorld, v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.texcoord.xy * _MianTex_ST.xy + _MianTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target{
                fixed3 albedo = tex2D(_MianTex, i.uv).rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLightDir));
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss); 

                return fixed4(ambient + diffuse + specular, 1.0);
            }

            ENDCG
        }
    }
}
