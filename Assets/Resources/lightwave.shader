Shader "Custom/Lightwave" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		#define VERTEX_P mediump
		#define FRAGMENT_P lowp
		#define PI 3.1415926535897932384626433832795
		
		const float position = 0.0;
        const float scale = 1.0;
        const float intensity = 1.0;

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float2 vPos : VPOS;
		};
		
		float band(float2 pos, float amplitude, float frequency) {
            float wave = scale * amplitude * sin(1.0 * PI * frequency * pos.x + time) / 2.05;
            float light = clamp(amplitude * frequency * 0.02, 0.001 + 0.001 / scale, 5.0) * scale / abs(wave - pos.y);
            return light;
        }

		void surf (Input IN, inout SurfaceOutput o) {
			
			// _Time[0]
			// _ScreenParams
			
			float3 color = float3(1.5, 0.5, 10.0);
			color = color == float3(0.0)? float3(10.5, 0.5, 1.0) : color;
			//float2 pos = (Input.vPos.xy / _ScreenParams.xy);
			//pos.y += - 0.5;
			
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = color.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}