Shader "CookBookShaders/Build-in Specular" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("Diffuse Tint",Color)=(1,1,1,1)
		_SpecColor("Specular Color",Color)=(1,1,1,1)
		_SpecPower("Specular Power",Range(0,1))=0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		//注意：这里指定了采用哪种光照模型，这里指定为 Build-in 的BlinnPhong;

		CGPROGRAM
		#pragma surface surf BlinnPhong


		//注意 : _SpecColor 是Unity Build-in变量，无需自己在SubShader中声明变量，只需在 Properties块中声明该变量;就是说变量是内置的，但是这个变量在编辑器中显示什么名字是我们来指定的(之前说过Propertices块中声明的变量是编辑器和CG的桥梁、中间件)

		sampler2D _MainTex;
		float4 _MainTint;
		float _SpecPower;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex)*_MainTint;

			o.Specular=_SpecPower; //传递到 BlinnPhong 光照模型函数中。

			o.Gloss=1.0;	//光滑度，用来控制高光的清晰度，值越大 越清晰，比如一块慢慢生锈的铁，就可以用Gloss慢慢减小，实现高光越来越弱的效果

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
