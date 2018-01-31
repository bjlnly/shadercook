Shader "CookBookShaders/BasicPhongSpecular" 
{
	Properties 
	{
		_MainTint("Diffuse Tint",Color) =(1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor("Specular Color",Color)=(1,1,1,1)
		_SpecularPower("Specular Power",Range(1,30))=1
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicPhongSpecular

		float4 _MainTint;
		sampler2D _MainTex;
		float4 _SpecularColor;
		float _SpecularPower;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		inline fixed4 LightingBasicPhongSpecular(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{

			//计算漫反射
			float diffuse=dot(s.Normal,lightDir);


			//计算反射光方向
			float3 reflectionVector=normalize( ( 2.0 * s.Normal * diffuse ) - lightDir); 


			//首先dot()求反射光与眼睛位置夹角cos值，眼睛位置越接近反射光，夹角越小，值越大，眼睛看到的光越亮。
			float specularLightPower=pow( max( 0,dot(reflectionVector,viewDir ) ) ,_SpecularPower );
			float3 specularColorFinal=_SpecularColor.rgb * specularLightPower;

			fixed4 c;
			c.rgb=( s.Albedo * _LightColor0.rgb * diffuse ) + ( _LightColor0.rgb * specularColorFinal ) ;
			//c.rgb=( s.Albedo * _LightColor0.rgb * diffuse );

			c.a=1.0;

			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
