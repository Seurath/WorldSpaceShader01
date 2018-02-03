// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WorldSpaceDissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NoiseScale("NoiseScale", Range( 1 , 1000)) = 1
		_DissolveDist("DissolveDist", Range( 0.01 , 10)) = 1
		_DissolveRange("DissolveRange", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma exclude_renderers metal xbox360 xboxone psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
		};

		uniform half _NoiseScale;
		uniform half _DissolveDist;
		uniform half _DissolveRange;
		uniform float _Cutoff = 0.5;


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
			float3 ase_worldPos = i.worldPos;
			float simplePerlin3D97 = snoise( (ase_worldPos*_NoiseScale + 0.0) );
			float temp_output_198_0 = ( ( (simplePerlin3D97*0.5 + 0.5) * ( distance( _WorldSpaceCameraPos , ase_worldPos ) - _DissolveDist ) ) - _DissolveRange );
			half3 temp_cast_0 = (temp_output_198_0).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = 1;
			clip( temp_output_198_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Standard"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
243;94;1084;573;409.7614;-73.34164;1.676654;False;False
Node;AmplifyShaderEditor.CommentaryNode;21;-1303.7,118.0274;Float;False;1137.152;390.9514;Noise;6;97;102;107;108;1;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;109;-701.6755,608.7125;Float;False;1214.18;600.0262;Cutoff;6;7;124;131;93;111;176;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1268.841,177.4767;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;108;-1252.946,376.2919;Float;False;Property;_NoiseScale;NoiseScale;3;0;Create;1;0;1;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;93;-681.0164,685.4126;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;111;-669.2647,847.8096;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;107;-879.4796,178.0611;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-422.9885,910.3464;Float;False;Property;_DissolveDist;DissolveDist;4;0;Create;1;1;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-353.2376,771.8335;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;97;-648.8345,172.7015;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-645.3377,256.251;Float;False;Constant;_ScaleAndOffset;ScaleAndOffset;4;0;Create;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;101;-445.918,223.514;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;-48.26511,773.7535;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;131.966,235.0576;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;263.544,313.6958;Float;False;Property;_DissolveRange;DissolveRange;6;0;Create;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;140.1816,-110.1008;Float;True;Property;_FrontTex;FrontTex;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;163;140.2739,-314.2944;Float;True;Property;_BackTex;BackTex;1;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;198;544.2969,238.9888;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;131;-644.6325,1044.483;Float;False;Property;_CameraPos;CameraPos;5;0;Create;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;957.3811,302.5464;Half;False;True;0;Half;ASEMaterialInspector;0;0;Standard;WorldSpaceDissolve;False;False;False;False;False;True;True;True;True;True;True;True;False;False;False;False;False;Off;0;0;False;0;0;Custom;0.5;True;False;0;True;TransparentCutout;Geometry;ForwardOnly;True;True;True;True;True;False;True;False;False;True;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;Standard;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;107;0;1;0
WireConnection;107;1;108;0
WireConnection;7;0;93;0
WireConnection;7;1;111;0
WireConnection;97;0;107;0
WireConnection;101;0;97;0
WireConnection;101;1;102;0
WireConnection;101;2;102;0
WireConnection;176;0;7;0
WireConnection;176;1;124;0
WireConnection;175;0;101;0
WireConnection;175;1;176;0
WireConnection;198;0;175;0
WireConnection;198;1;167;0
WireConnection;0;0;198;0
WireConnection;0;10;198;0
ASEEND*/
//CHKSM=7C336F950E5C182139D7573C14CF44969CAE428B