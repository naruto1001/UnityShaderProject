// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/WaterDropShader"
{
    Properties{
        _MainTex ("MainTex", 2D) = "white"{}
        _Size("Size", Int) = 1

    }
    SubShader{
        Pass {
            Tags {}
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            float4 _MainTex_ST;
            int _Size;

            struct a2v{
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0; 
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target{
                float4 col = 0;

                float2 aspect = float2(2, 1);
                float2 uv = i.uv * _Size * aspect;
                float2 gv = frac(uv) - 0.5;

                float drop = smoothstep(0.05, 0.01, length(gv / aspect));

                //col += drop;
                col.rg = gv;
                return col;
            }

            ENDCG
        }
    }
}
