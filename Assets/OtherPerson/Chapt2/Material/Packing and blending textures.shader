Shader "CookBookShaders/Packing and blending textures" 
{
	Properties 
	{
		_Shitou_Texture ("Shitou Texture",2D)="white"{}
		_Cao_Texture ("Cao Texture",2D)="white"{}
		_Shazi_Texture ("Shazi Texture",2D)="white"{}
		_Niba_Texture ("Niba Texture",2D)="white"{}

		_BlendTexture("Blend Texture",2D)="white"{}
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		//#pragma target 4.0

		sampler2D _Shitou_Texture;  //石头
		sampler2D _Cao_Texture;		//草
		sampler2D _Shazi_Texture;    //沙子
		sampler2D _Niba_Texture;    //泥巴

		sampler2D _BlendTexture; //记录了上面图片 图与图 混合的系数的灰度图,比如 R 通道记录着 石头 和 草的混合系数，G 通道记录着上面混合结果 再与 沙子 混合的系数。。灰度图 其实它不是作为图片存在的，只是作为记录数据而用，比如记录5张图片的混合信息，比如记录4张图片的Alpha，比如计算地形的高度，海拔高的这一点就记录为1，海拔低就记录为0.

		

		struct Input 
		{
			float2 uv_Shitou_Texture;
			float2 uv_Cao_Texture;
			//float2 uv_Shazi_Texture;
			float2 uv_Niba_Texture;

			float2 uv_BlendTexture;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float4 blendData=tex2D(_BlendTexture,IN.uv_BlendTexture);//从记录着混合系数的灰度图中读出所有的混合数据

			float4 shitouData=tex2D(_Shitou_Texture,IN.uv_Shitou_Texture);//读出石头 这个坐标的颜色数据;
			float4 caoData=tex2D(_Cao_Texture,IN.uv_Cao_Texture);
			//float4 shaziData=tex2D(_Shazi_Texture,IN.uv_Shazi_Texture);
			float4 nibaData=tex2D(_Niba_Texture,IN.uv_Niba_Texture);

			float4 finalColor;

			//混合石头和草
			finalColor = lerp(shitouData,caoData,blendData.r); //根据 灰度图中 R 通道中的数值 来对 石头 和 草 进行插值。
			//finalColor = lerp(finalColor,shaziData,blendData.g);
			finalColor = lerp(finalColor,nibaData,blendData.b);
			finalColor.a=1;

			o.Albedo = finalColor.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
