Shader "CookbookShaders/BasicDiffuse" {
	Properties {
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue("This is a Slider",Range(0,10)) = 2.5
		_RampTex("RampTex",2D) = "white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows

		#pragma surface surf BasicDiffuse
		sampler2D _RampTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float difLight = max(0,dot(s.Normal, lightDir));
			float hLambert = difLight * 0.5 + 0.5;
			float3 ramp = tex2D(_RampTex, float2(hLambert,hLambert)).rgb;

			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * ramp;//(hLambert * atten * 2);
			col.a = s.Alpha;
			return col;
		}
		
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
