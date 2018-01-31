Shader "CookBookShaders/Ramp Texture" {
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
		#pragma surface surf rampTextureDiffuse

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
		inline half4 LightingrampTextureDiffuse(SurfaceOutput s,half3 lightDir,half atten)
		{
			float difLight = max(0,dot(s.Normal,lightDir) );//dot表示cos值，范围(-1,1) max将difLight的范围限定到了(0,1)
	
			float3 ramp=tex2D( _RampTex , float2(difLight,difLight)).rgb;

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
