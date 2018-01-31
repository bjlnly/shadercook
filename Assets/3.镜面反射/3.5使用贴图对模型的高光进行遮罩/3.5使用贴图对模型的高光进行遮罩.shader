Shader "CookbookShaders/3.5使用贴图对模型的高光进行遮罩" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor ("Specular Tint", Color) = (1,1,1,1)
		_SpecularMask ("Specular Texture", 2D) = "White" {}
		_SpecPower("Specular Power", Range(0.1, 120)) = 3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomPhong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _SpecularMask;
		float4 _SpecularColor;
		fixed4 _Color;
		float _SpecPower;



		struct SurfaceCustomOutput{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};
		inline fixed4 LightingCustomPhong (SurfaceCustomOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		//inline fixed4 LightingCustomPhong(SurfaceCustomOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			// 首先计算漫反射;  
			float diff = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);

			// 计算高光模型
			float spec = pow(max(0.0f, dot(reflectionVector, viewDir)), _SpecPower) * s.Specular;
			float3 finalSpec = s.SpecularColor * spec * _SpecularColor.rgb;

			// 计算最终颜色
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float2 uv_MainTex;
			float2 uv_SpecularMask;
		};
		
		void surf (Input IN, inout SurfaceCustomOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			//用r值作为系数，如果当前UV坐标是位于铁片里面黑色的那一块，那么rgb都是0，这样里面黑色的那一块其实是无效的。  
			float4 specMask = tex2D(_SpecularMask, IN.uv_SpecularMask) * _SpecularColor;
			o.Specular = specMask.r;
			//接收高光的，高光贴图，例如铁皮  
			o.SpecularColor = specMask.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
