Shader "CookbookShaders/SpriteAni" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_TexWidth("Sheet Width", float) = 0.0
		_CellAmount("Cell Amount", float) = 0.0
		_Speed("Speed", Range(0.01, 32)) = 12
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _TexWidth;
		float _CellAmount;
		float _Speed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// UV 暂存
			float2 spriteUV = IN.uv_MainTex;
			// 计算每个小sprite的宽度
			float cellPixelWidth = _TexWidth/_CellAmount;
			// 计算每个小sprite占整张图的比例
			float cellUVPercentage = cellPixelWidth/_TexWidth;
			// 1秒几格的问题
			float timeVal = fmod(_Time.y * _Speed, _CellAmount);
			// 取整
			timeVal = ceil(timeVal);
			float xValue = spriteUV.x;

			xValue += cellUVPercentage * timeVal * _CellAmount;
			xValue *= cellUVPercentage;

			spriteUV = float2(xValue, spriteUV.y);
			half4 c = tex2D(_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
