Shader "CookBookShaders/Sprite Sheet Anim (C#)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_cellIndex ("Time Value",float) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _cellIndex;


		struct Input {
			float2 uv_MainTex;
			
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed2 spriteUV = IN.uv_MainTex;

			float cellPercentage = 1.0 / 9; //每一个小图占百分比;

			float xValue=spriteUV.x;

			//UV默认是(0,1)，就是说默认显示整个大图，我们要显示一个小图,UV要指定到(0,1/9)的范围;
			xValue=xValue*(1.0/9);

			//再对时间取整，如果 _Time.y 时间超过了1，就加一个小图这么宽的位移，也就是把x 指到下一个小图的范围。就显示出下一个小图
			xValue+=cellPercentage * _cellIndex;

			//再赋值;
			spriteUV = float2(xValue,spriteUV.y);
			
			half4 c = tex2D (_MainTex, spriteUV);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
