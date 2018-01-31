Shader "CookbookShaders/法线贴图" {
	Properties {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_NormalTex("Normal Map", 2D) = "bump"{}
		_NormalIntensity ("Normal Map Intensity", Range(0,2)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _NormalTex;
		float4 _MainTint;
		float _NormalIntensity;

		struct Input {
			float2 uv_NormalTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
