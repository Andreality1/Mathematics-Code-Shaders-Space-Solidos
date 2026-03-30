Shader "Unlit/Shader_Graphics_PlotFunction_1"
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



            fixed4 frag (PixelData i) : SV_Target
            {
            
                float2 uv =  i.uv ;

                float4 colorWhite = float4(1,1,1,1); // Color white.
                float4 colorBlack = float4(0,0,0,1); // Color Black.

                float2 coordinateScale = (uv * 2.0)  - 1.0;
            	coordinateScale = coordinateScale/(float2(0.55555, 1.0));
                
                // float x = i.uv.x; // Range 0 to 1
                // float y = i.uv.y; // Range 0 to 1
                
                float x = coordinateScale.x; // Range 0 to 1
                float y = coordinateScale.y; // Range 0 to 1

                // Define the function
                // float f_x = x; 
                // Quadratic Polynomial: y = x^2
                // float f_x = 1/(1 + 25 * x * x);
                float f_x = cos(10 * x + _Time.y) ;
                // Check distance
                float thickness = 0.1;
                float sdf = smoothstep(thickness, 0.0, abs(y - f_x));
    
    
                float4 col = colorBlack;

                col =  fixed4(0, sdf, 0, 1); // Green line

                return col;

            }    

            ENDCG
        }
    }
}
