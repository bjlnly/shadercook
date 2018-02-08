Shader "CookbookShaders/4.4法线贴图" 
{
	Properties 
	{
		_MainTint("Diffuse Color",Color)=(1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}

		_NormalMap("Normal Map",2D) = "bump"{}

		_Cubemap("Cubemap",CUBE)=""{}

		_ReflAmount("Reflection Amount",Range(0,1))=0.5
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		float4 _MainTint;
		sampler2D _MainTex;

		sampler2D _NormalMap;

		samplerCUBE _Cubemap;

		float _ReflAmount;



		struct Input 
		{
			float2 uv_MainTex;

			float2 uv_NormalMap;

			float3 worldRefl;

			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			//从法线贴图中提取法线信息，UnpackNormal这个函数在 CGInclude 文件夹中的Lighting中。
			float3 normals=UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));

			o.Normal=normals;

			//上面使用法线贴图中的法线数据 替代了 原来的法线数据。

			//法线被修改了，就不能 直接用原来的 内置属性 worldRefl 这个反射向量，而是要通过 WorldReflectionVector(IN,o.Normal)来获取。

			//使用WorldReflectionVector 获得 基于法线贴图中的反射向量的 世界反射向量
			o.Emission = texCUBE(_Cubemap,WorldReflectionVector(IN,o.Normal)).rgb * _ReflAmount;

			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
