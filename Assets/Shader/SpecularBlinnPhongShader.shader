// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SpecularBlinnPhongShader"
{
   Properties{
    _Diffuse ("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    _Specular ("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
    _Gloss ("Gloss", Range(8.0, 256.0)) = 20.0
   }
   SubShader {
    Pass {
        Tags { "LightModel" = "ForwardBase" }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "Lighting.cginc"

        fixed4 _Diffuse;
        fixed4 _Specular;
        float _Gloss;

        struct a2v{
            float4 vertex : POSITION;
            float3 normal : NORMAL;
        }; 

        struct v2f{
            float4 pos : SV_POSITION;
            float3 worldNormal : TEXCOORD0;
            float4 worldPos : TEXCOORD1; 
        }; 

        v2f vert(a2v v){
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.worldNormal = mul((float3x3)unity_ObjectToWorld, v.normal);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex);
            return o;
        }

        fixed4 frag(v2f i) : SV_Target{
            fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
            fixed3 worldNormal = normalize(i.worldNormal);
            fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
            fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
            fixed3 halfDir = normalize(viewDir + worldLightDir);
            fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
            fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
            fixed3 color = ambient + diffuse + specular;
            return fixed4(color, 1.0);
        }

        ENDCG
        }
    }
}
