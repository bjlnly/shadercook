Shader "CookBookShaders/CustomBlinnPhong" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("Main Tint",Color)=(1,1,1,1)
		_SpecularColor("Specular Color",Color)=(1,1,1,1)
		_SpecularPower("Specular Power",Range(0.1,120))=1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		sampler2D _MainTex;
		float4 	  _MainTint;
		float4    _SpecularColor;
		float     _SpecularPower;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		fixed4 LightingCustomBlinnPhong(SurfaceOutput s,fixed3 lightDir,fixed3 viewDir,fixed atten)
		{
			float3 diffuse = max(0,dot(s.Normal , lightDir));

			float3 halfVector=normalize(lightDir + viewDir);
			float specular=max(0, dot( s.Normal , halfVector ));
			float finalSpecular=pow(specular,_SpecularPower);

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diffuse) +( _LightColor0.rgb * _SpecularColor.rgb * finalSpecular)*(atten*2);
			c.a=s.Alpha;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
