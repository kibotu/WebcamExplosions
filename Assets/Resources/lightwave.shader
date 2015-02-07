Shader "Custom/lightwave" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		#define PI 3.1415926535897932384626433832795
		const float position = 0.0;
        const float scale = 1.0;
        const float intensity = 1.0;

		struct Input {
			float2 uv_MainTex;
		};
		
		float band(float4 pos, float amplitude, float frequency) {
            float4 wave = scale * amplitude * sin(1.0 * PI * frequency * pos.x + _Time[0]) / 2.05;
            float light = clamp(amplitude * frequency * 0.02, 0.001 + 0.001 / scale, 5.0) * scale / abs(wave - pos.y);
            return light;
        }

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			half3 color = half3(1.5, 0.5, 10.0);
            color = color == vec3(0.0)? vec3(10.5, 0.5, 1.0) : color;

			half2 resolution = half2(800.0,500.0);

            float4 pos = float4(c.xy / resolution.xy);
            pos.y += - 0.5;
            float spectrum = 0.0;
            const float lim = 28.0;
            #define time _Time[0]*0.037 + pos.x*10.
            for(float i = 0.0; i < lim; i++){
				spectrum += band(pos, 1.0*sin(time*0.1/PI), 1.0*sin(time*i/lim))/pow(lim, 0.25);
            }

            spectrum += band(pos, cos(10.7), 2.5);
            spectrum += band(pos, 0.4, sin(2.0));
            spectrum += band(pos, 0.05, 4.5);
            spectrum += band(pos, 0.1, 7.0);
            spectrum += band(pos, 0.1, 1.0);

			half4 bla = half4(color * spectrum, spectrum);

			o.Albedo =  bla.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}