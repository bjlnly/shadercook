Shader "CookBookShaders/BasicDiffuse" {
	Properties {
		_EmissiveColor("Emissive Color",Color) = (1,1,1,1) //设置默认值
		_EmissivePowValue("EmissivePow Value",Range(0,10)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicDiffuse

		float4 _EmissiveColor;
		float _EmissivePowValue;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c=pow(_EmissiveColor,_EmissivePowValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		//不需要视角方向的前向着色
		inline half4 LightingBasicDiffuse(SurfaceOutput s,half3 lightDir,half atten)
		{
			float difLight = max(0,dot(s.Normal,lightDir) );

			half4 color=(0,0,0,0);
			color.rgb=s.Albedo * _LightColor0.rgb * ( difLight * atten * 2 );
			color.a=s.Alpha;
			return color;
		}

		//需要视角方向的前向着色
		inline half4 LightingBasicDiffuseWithViewDir(SurfaceOutput so,half3 lightDir,half3 viewDir,half atten)
		{
			half4 color=(0,0,0,0);

			return color;
		}

		//需要使用延迟着色
		inline half4 LightingBasicDiffuse_PrePass(SurfaceOutput so,half4 light)
		{
			half4 color=(0,0,0,0);

			return color;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
