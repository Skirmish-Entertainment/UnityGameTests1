﻿Shader "Unlit/BackgroundSlide"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScrollSpeed("Scroll Speed", Float) = 0
		_Lightness("Color Multiplier", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _ScrollSpeed;
			float _Lightness;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				
				o.uv = TRANSFORM_TEX(v.uv, _MainTex) ;
				
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				i.uv.x += _Time * -_ScrollSpeed;
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= _Lightness;
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
