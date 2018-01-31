Shader "CookbookShaders/3.3创建phong高光模型" {
	Properties {
		_MainTex ("Base(RGB)", 2D) = "white"{}
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_SpecColor("Specular Color", Color) = (1,1,1,1)
		_SpecPower("Specular Power", Range(1,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf BasicPhongSpecular

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		sampler2D _MainTex;
		//float4 _SpecColor;
		float _SpecPower;
		float4 _MainTint;
		struct Input {
			float2 uv_MainTex;
		};
		//需要视角方向的前向着色  
		inline fixed4 LightingBasicPhongSpecular(SurfaceOutput s,half3 lightDir,half3 viewDir,half atten)  
		{  
    		//计算漫反射  
            float diffuse=dot(s.Normal,lightDir);  
  
  
            //计算反射光方向  
            float3 reflectionVector=normalize( ( 2.0 * s.Normal * diffuse ) - lightDir);   
  
  
            //首先dot()求反射光与眼睛位置夹角cos值，眼睛位置越接近反射光，夹角越小，值越大，眼睛看到的光越亮。  
            float specularLightPower=pow( max( 0,dot(reflectionVector,viewDir ) ) ,_SpecPower);  
            float3 specularColorFinal=_SpecColor.rgb * specularLightPower;  
  
            fixed4 c;  
            c.rgb=( s.Albedo * _LightColor0.rgb * diffuse ) + ( _LightColor0.rgb * specularColorFinal ) ;  
            //c.rgb=( s.Albedo * _LightColor0.rgb * diffuse );  
  
            c.a=1.0;  
  
            return c;  
		}  

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
