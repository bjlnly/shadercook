Shader "CookBookShaders/Ramp Texture Half Lambert" {
	Properties {
		_EmissiveColor("Emissive Color",Color) = (1,1,1,1) //设置默认值
		_AmbientColor("Ambient Color",Color) = (1,1,1,1)
		_PowValue("Power Value",Range(-1,1)) = 1
		_RampTex("Ramp Texture",2D) = "" //添加_RampTex属性接受一个Texture
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf rampHalfLambertDiffuse

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _PowValue;
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c=pow((_EmissiveColor+_AmbientColor),_PowValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		//不需要视角方向的前向着色
		inline half4 LightingrampHalfLambertDiffuse(SurfaceOutput s,half3 lightDir,half atten)
		{
			float difLight = max(0,dot(s.Normal,lightDir) );//dot表示cos值，范围(-1,1) max将difLight的范围限定到了(0,1)
			float hLambert = difLight * 0.5 +0.5;//Half Lamert光照模型就表现在这一句，将漫反射的光照值范围限定到了 (0.5,1)，所以原来是 0 的地方现在就是 0.5 了，明亮度顿时提升，而原来已经很亮的地方并没有很大的变化。
			float3 ramp=tex2D( _RampTex , float2(hLambert,hLambert)).rgb;

			half4 color=(0,0,0,0);
			color.rgb=s.Albedo * _LightColor0.rgb * (ramp);
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
