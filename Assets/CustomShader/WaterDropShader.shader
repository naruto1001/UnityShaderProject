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
                float t = _Time.y;

                float2 aspect = float2(2, 1);
                float2 uv = i.uv * _Size * aspect;
                //控制UV运动配合水滴下落
                uv.y += t * 0.25;
                float2 gv = frac(uv) - 0.5;

                float x = 0;
                float y = -sin(t + sin(t + sin(t) * 0.5)) * 0.45;
                float2 dropPos = (gv - float2(x, y)) / aspect; 

                float drop = smoothstep(0.05, 0.03, length(dropPos));

                float2 dropTrailPos = (gv - float2(x, 0)) / aspect;
                dropTrailPos.y = (frac(dropTrailPos.y * 8) / 8)-0.03;
                float dropTrail = smoothstep(0.03, 0.02, length(dropTrailPos));

                dropTrail *= smoothstep(-0.05, 0.05, dropPos.y);
                //dropTrail *= smoothstep(0.5, y, gv.y);

                if(gv.x > 0.48 || gv.y > 0.48){
                    return float4(1, 0, 0, 0);
                }

                col += drop;
                col += dropTrail;
                return col;
            }

            ENDCG
        }
    }
}
