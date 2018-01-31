Shader "CookBookShaders/BRDF" {
	Properties {
		_EmissiveColor("Emissive Color",Color) = (1,1,1,1) //设置默认值
		_AmbientColor("Ambient Color",Color) = (1,1,1,1)
		_PowValue("Power Value",Range(0,10)) = 2.5
		_RampTex("Ramp Texture",2D) = "" //添加_RampTex属性接受一个Texture
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicDiffuseWithViewDir

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _PowValue;
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float4 c;
			c=pow((_EmissiveColor+_AmbientColor),_PowValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		//需要视角方向的前向着色
		inline float4 LightingBasicDiffuseWithViewDir(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			float difLight=dot(s.Normal , lightDir); //根据法线与光照方向的夹角计算cos值
			float rimLight=dot(s.Normal , viewDir);
			float hLambert=difLight * 0.5 + 0.5;
			float3 ramp = tex2D(_RampTex,float2(hLambert,rimLight)).rgb;

			float4 col;
			col.rgb=s.Albedo * _LightColor0.rgb * (ramp);
			col.a=s.Alpha;
			return col;
		}

		ENDCG
	} 
	//FallBack "Diffuse"
}
