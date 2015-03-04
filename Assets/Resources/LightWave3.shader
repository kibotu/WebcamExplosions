Shader "Custom/LightWave3" {
	Properties 
	{ 
		_Wpos("Wpos", Vector) = (0,0,0,0) 
		_scale ("scale", Float) = 1.0
		_intensity ("intensity", Float) = 1.0 
		_lim ("lim", Float) = 28.0
		_speed ("speed", Float) = 1.0
		_tolerance ("tolerance", Float) = 1.0
		_MainTex ("Color (RGB) Alpha (A)", 2D) = "white"
	}
	SubShader {
		Pass {
			Tags { "Queue"="Transparent" "RenderType"="Transparent" }
			Fog { Mode Off }
			Lighting Off
			Fog { Mode Off }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members wpos)
			#pragma exclude_renderers d3d11 xbox360

			#pragma vertex vert
			#pragma fragment frag 
			#pragma target 3.0

			#define VERTEX_P mediump
			#define FRAGMENT_P lowp
			#define PI 3.1415926535897932384626433832795

			float _scale;
			float _lim;
			float4 _Wpos;
			float _speed;
			float _tolerance;
			sampler2D _MainTex;

			// vertex input: position, normal, tangent
			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT; 
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float4 color : COLOR;
				float4 wpos;
				float4 uv : TEXCOORD0;
			};
        
			v2f vert (appdata v) {
				v2f o;
				o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
				o.wpos =  mul( UNITY_MATRIX_MVP, v.vertex);
				// calculate binormal
				float3 binormal = cross( v.normal, v.tangent.xyz ) * v.tangent.w;
				o.color.xyz = binormal * 0.5 + 0.5;
				o.color.w = 1.0;
				o.uv = float4( v.texcoord.xy, 0, 0 );
				return o;
			}			
        
			float band(float2 pos, float amplitude, float frequency) {
				float wave = _scale * amplitude * sin(1.0 * PI * frequency * pos.x + _Time.x * _speed) / 2.05;
				float light = clamp(amplitude * frequency * 0.02, 0.001 + 0.001 / _scale, 5.0) * _scale / abs(wave - pos.y);
				return light;
			}

			fixed4 frag (v2f i) : COLOR0 {
			
				float4 color = float4(1.5, 0.5, 10.0, 1.0);

				//float2 p = i.wpos.xy/_ScreenParams.xy;
				float2 p = i.wpos .xy;

				//p.y += - 0.5;
				float spectrum = 0.0;
				float time = _Time.x*_speed*0.037 + p.x*10.0;

				for(float i = 0.0; i < _lim; i++) {
					spectrum += band(p, 1.0*sin(time*0.1/PI), 1.0*sin(time*i/_lim)/pow(_lim, 0.25));
				}
				
				spectrum += band(p, cos(10.7), 2.5);
				spectrum += band(p, 0.4, sin(2.0));
				spectrum += band(p, 0.05, 4.5);
				spectrum += band(p, 0.1, 7.0);
				spectrum += band(p, 0.1, 1.0);

				float4 c = color * spectrum;

				//if(i.wpos.y > 0.5*sin(_Time.y) + 500)
                 //  return i.color;
                

				float4 result = float4(c.r * spectrum, c.g * spectrum, c.b * spectrum, spectrum); 

				if(result.r + result.g + result.b  > _tolerance)
					return result;
				else 
					return float4(1.0,0,0,0);
			 }
			 ENDCG
		}
	}
}