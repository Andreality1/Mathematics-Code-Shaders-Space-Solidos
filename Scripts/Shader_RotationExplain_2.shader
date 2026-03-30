Shader "Unlit/Shader_Graphics_RotationExplain_2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StepTime ("Step Time", Float) = 0.0
    }
    SubShader
    {


        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert alpha
            #pragma fragment frag alpha

            #include "UnityCG.cginc"

            struct VertexInfo
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
            };

            struct PixelData
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            int _SetScreen ;
            float _StepTime; // This receives the value from C#


            PixelData vert (VertexInfo v)
            {
                PixelData o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float2x2 rotationMatrix(float rotationAngle)
            {
                float2x2 rot = float2x2(cos(rotationAngle), 
                                        -sin(rotationAngle), 
                                                            sin(rotationAngle),
                                                            cos(rotationAngle));

                return rot;
            }


            fixed4 frag (PixelData i) : SV_Target
            {
            
                float2 uv =  i.uv ;

                float4 colorWhite = float4(1,1,1,1); // Color white.
                float4 colorBlack = float4(0,0,0,1); // Color Black.

                float2 coordinateScale = (uv * 2.0)  - 1.0;
            	coordinateScale = coordinateScale/(float2(0.55555, 1.0));

                float2 size = float2(0.5 ,0.5);
                float2 position = float2(0.5, 0.5);
                float2x2 matrixOut = rotationMatrix(_Time.y);
                position = mul(matrixOut, position);
                float2 screenSpace = coordinateScale - position;


                float disHypotenuse = dot(size, screenSpace ) - (size.x * size.y); 

                screenSpace = -screenSpace;

                float sdf = max(max(screenSpace.x, screenSpace.y), disHypotenuse);

                float shader = 1.0 - smoothstep(0.0, 0.01, sdf);

                float4 col = colorBlack;

                col = fixed4(shader, shader, shader, 1.0);

                return col;

            

            }    

            ENDCG
        }
    }
}
