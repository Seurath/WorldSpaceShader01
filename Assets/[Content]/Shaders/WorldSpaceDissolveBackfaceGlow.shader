// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WorldSpaceDissolveBackfaceGlow"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0
		_FrontTex("FrontTex", 2D) = "white" {}
		_NoiseScale("NoiseScale", Range( 1 , 1000)) = 1
		_DissolveDist("DissolveDist", Range( 0.01 , 10)) = 1
		_DissolveRange("DissolveRange", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers metal xbox360 xboxone psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			half2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _FrontTex;
		uniform float4 _FrontTex_ST;
		uniform half _DissolveDist;
		uniform half _DissolveRange;
		uniform half _NoiseScale;
		uniform float _Cutoff = 0;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FrontTex = i.uv_texcoord * _FrontTex_ST.xy + _FrontTex_ST.zw;
			o.Albedo = tex2D( _FrontTex, uv_FrontTex ).rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float temp_output_176_0 = ( distance( _WorldSpaceCameraPos , ase_worldPos ) - _DissolveDist );
			float simplePerlin3D97 = snoise( (ase_worldPos*_NoiseScale + 0.0) );
			clip( (( temp_output_176_0 < _DissolveRange ) ? ( (simplePerlin3D97*0.5 + 0.5) * temp_output_176_0 ) :  1.0 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Standard"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
243;94;1084;573;1283.013;540.8461;2.492395;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-984.6733,130.4893;Float;False;1079.827;380.9818;;6;101;97;102;107;108;1;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-933.9195,388.7538;Float;False;Property;_NoiseScale;NoiseScale;3;0;Create;1;0;1;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-949.8145,189.9386;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;109;-701.6755,608.7125;Float;False;1278.982;475.4064;;8;211;175;167;176;124;7;111;93;Cutoff;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;107;-560.4531,190.523;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;111;-669.2647,847.8096;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;93;-681.0164,685.4126;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;97;-329.8079,185.1634;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-378.5349,957.4359;Float;False;Property;_DissolveDist;DissolveDist;4;0;Create;1;1;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-304.6147,778.5401;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-326.3111,268.7129;Float;False;Constant;_ScaleAndOffset;ScaleAndOffset;4;0;Create;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;-38.6595,777.8796;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;101;-126.8914,235.9759;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;193.6436,655.6853;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;67.52374,957.9841;Float;False;Property;_DissolveRange;DissolveRange;5;0;Create;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;302.1873,156.5855;Float;True;Property;_FrontTex;FrontTex;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;163;302.2795,-47.60816;Float;True;Property;_BackTex;BackTex;1;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareLower;211;395.1316,769.4675;Float;False;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;898.6981,158.3542;Half;False;True;2;Half;ASEMaterialInspector;0;0;Standard;WorldSpaceDissolveBackfaceGlow;False;False;False;False;False;True;True;True;True;True;True;True;False;False;False;False;False;Off;0;0;False;0;0;Custom;0;True;False;0;True;TransparentCutout;Geometry;ForwardOnly;True;True;True;True;True;False;True;False;False;True;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;Standard;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;107;0;1;0
WireConnection;107;1;108;0
WireConnection;97;0;107;0
WireConnection;7;0;93;0
WireConnection;7;1;111;0
WireConnection;176;0;7;0
WireConnection;176;1;124;0
WireConnection;101;0;97;0
WireConnection;101;1;102;0
WireConnection;101;2;102;0
WireConnection;175;0;101;0
WireConnection;175;1;176;0
WireConnection;211;0;176;0
WireConnection;211;1;167;0
WireConnection;211;2;175;0
WireConnection;0;0;2;0
WireConnection;0;10;211;0
ASEEND*/
//CHKSM=FC4D424CE669DD2DC18A9FF5B285847F628841A1