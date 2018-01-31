Shader "CookBookShaders/Metallicsoft" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Diffuse Tint",Color)=(1,1,1,1)
		_RoughnessTex("Roughness Texture",2D)="white"{}
		_Roughness("Roughness",Range(0,1))=0.5
		_SpecularColor("Specular Color",Color)=(1,1,1,1)
		_SpecularPower("Specular Power",Range(0,30))=2
		_Fresnel("Fresnel",Range(0,1.0))=0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Metallicsoft

		sampler2D _MainTex;
		float4  _MainTint;
		sampler2D _RoughnessTex;
		float _Roughness;
		float4 _SpecularColor;
		float _SpecularPower;
		float _Fresnel;


		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		inline fixed4 LightingMetallicsoft(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			//先计算出来所有的漫反射以及视点相关的向量;
			float3 halfVector=normalize(lightDir + viewDir);
			float NdotL=saturate(dot(s.Normal,normalize(lightDir)));
			float NdotH_raw=dot(s.Normal,halfVector);
			float NdotH = saturate(dot(s.Normal,halfVector));
			float NdotV=saturate(dot(s.Normal,normalize(viewDir)));
			float VdotH=saturate(dot(halfVector,normalize(viewDir)));

			//生成一些粗糙度值，然后从纹理中读取高光形状
			float geoEnum=2.0*NdotH;
			float3 G1=(geoEnum * NdotV)/NdotH;
			float3 G2=(geoEnum * NdotL)/NdotH;
			float3 G= min(1.0f,min(G1,G2));

			float roughness=tex2D(_RoughnessTex,float2(NdotH_raw * 0.5 +0.5,_Roughness)).r;

			//菲涅尔准则;当我们视线正好对着物体表面时，会帮我们屏蔽高光;
			float fresnel=pow(1.0-VdotH,5.0);
			fresnel*=(1.0-_Fresnel);
			fresnel+=_Fresnel;

			//组合计算高光值;
			float3 specular=float3(fresnel * G * roughness * roughness) * _SpecularPower;

			//漫反射 加上 高光 
			float4 c;
			c.rgb=(s.Albedo * _LightColor0.rgb * NdotL)+(specular * _SpecularColor.rgb)*(atten * 2.0f);
			c.a=s.Alpha;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
