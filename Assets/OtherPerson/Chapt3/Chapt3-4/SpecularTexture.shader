Shader "CookBookShaders/SpecularTexture" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}

		_SpecularColor("Specular Color",Color)=(1,1,1,1)

		_SpecularTexture("Specular Texture",2D)="white" {}

		_SpecularPower("Specular Power",Range(0.1,120))=1
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomPhong

		sampler2D _MainTex;

		float4 _SpecularColor;
		sampler2D _SpecularTexture;
		float _SpecularPower;


		struct CustomSurfaceOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			half Specular;
			fixed3 SpecularColor;
			fixed Gloss;
			fixed Alpha;
		};

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_SpecularTexture;
		};

		void surf (Input IN, inout CustomSurfaceOutput o) 
		{
			//不接受高光的，漫反射贴图，例如木头
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			//接收高光的，高光贴图，例如铁皮
			half4 specularC=tex2D(_SpecularTexture,IN.uv_SpecularTexture);
			o.SpecularColor=specularC.rgb;

			//用r值作为系数，如果当前UV坐标是位于铁片里面黑色的那一块，那么rgb都是0，这样里面黑色的那一块其实是无效的。
			o.Specular =specularC.r;     
		}


		inline fixed4 LightingCustomPhong(CustomSurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{

			//首先计算漫反射;
			float diffuse=max(0,dot(s.Normal,lightDir));

			//计算漫反射颜色;
			float3 diffuseColor=_LightColor0*s.Albedo * diffuse;

			//计算反射光方向向量
			float3 halfReflectVector=normalize(lightDir + viewDir);

			//计算反射光强度;如果当前位置是铁片黑色的那一块，那么Specular是0，这里就没有高光了。
			float specular = pow( max(0,dot(s.Normal,halfReflectVector)) , _SpecularPower) * s.Specular;

			//计算高光颜色  高光贴图采样颜色 * 反射光强度 * 编辑器中指定的高光颜色 * 光照颜色;
			float3 specularColor =_LightColor0.rgb* s.SpecularColor * specular * _SpecularColor.rgb *(atten*5);


			fixed4 c;
			c.rgb=diffuseColor + specularColor;
			c.a=s.Alpha;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
