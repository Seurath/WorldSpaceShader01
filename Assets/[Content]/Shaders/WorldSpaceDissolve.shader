// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WorldSpaceDissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_FrontTex("FrontTex", 2D) = "white" {}
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
		#pragma target 2.0
		#pragma exclude_renderers metal xbox360 xboxone psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			half2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _FrontTex;
		uniform float4 _FrontTex_ST;
		uniform half _DissolveRange;
		uniform half _DissolveDist;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FrontTex = i.uv_texcoord * _FrontTex_ST.xy + _FrontTex_ST.zw;
			half4 tex2DNode2 = tex2D( _FrontTex, uv_FrontTex );
			float3 ase_worldPos = i.worldPos;
			float temp_output_182_0 = saturate( ( distance( _WorldSpaceCameraPos , ase_worldPos ) - _DissolveDist ) );
			float lerpResult185 = lerp( 0.0 , ( 1.0 - _DissolveRange ) , temp_output_182_0);
			float4 temp_output_184_0 = ( tex2DNode2 + lerpResult185 );
			o.Albedo = temp_output_184_0.rgb;
			o.Alpha = 1;
			clip( temp_output_184_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Standard"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
243;94;1084;652;604.9523;-18.35881;1.989067;False;False
Node;AmplifyShaderEditor.CommentaryNode;109;-701.6755,608.7125;Float;False;1214.18;600.0262;Cutoff;11;7;124;131;93;111;167;176;182;183;185;186;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;93;-681.0164,685.4126;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;111;-669.2647,847.8096;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;124;-422.9885,910.3464;Float;False;Property;_DissolveDist;DissolveDist;4;0;Create;1;1;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-353.2376,771.8335;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;-48.26511,773.7535;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-422.9027,990.3826;Float;False;Property;_DissolveRange;DissolveRange;6;0;Create;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;182;134.9803,774.2042;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;186;-69.89334,1038.75;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;140.1816,-110.1008;Float;True;Property;_FrontTex;FrontTex;2;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-1303.7,118.0274;Float;False;1137.152;390.9514;Noise;6;97;102;107;108;1;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;185;335.8763,1016.871;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1268.841,177.4767;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;108;-1252.946,376.2919;Float;False;Property;_NoiseScale;NoiseScale;3;0;Create;1;0;1;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;131;-644.6325,1044.483;Float;False;Property;_CameraPos;CameraPos;5;0;Create;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;101;-445.918,223.514;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;670.3747,389.7551;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;163;140.2739,79.36742;Float;True;Property;_BackTex;BackTex;1;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;97;-648.8345,172.7015;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;107;-879.4796,178.0611;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-645.3377,256.251;Float;False;Constant;_ScaleAndOffset;ScaleAndOffset;4;0;Create;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;184;677.9955,555.4068;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;339.8544,774.2041;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;957.3811,302.5464;Half;False;True;0;Half;ASEMaterialInspector;0;0;Standard;WorldSpaceDissolve;False;False;False;False;False;True;True;True;True;True;True;True;False;False;False;False;False;Off;0;0;False;0;0;Custom;0.5;True;False;0;True;TransparentCutout;Geometry;ForwardOnly;True;True;True;True;True;False;True;False;False;True;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;Standard;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;93;0
WireConnection;7;1;111;0
WireConnection;176;0;7;0
WireConnection;176;1;124;0
WireConnection;182;0;176;0
WireConnection;186;0;167;0
WireConnection;185;1;186;0
WireConnection;185;2;182;0
WireConnection;101;0;97;0
WireConnection;101;1;102;0
WireConnection;101;2;102;0
WireConnection;175;0;2;0
WireConnection;175;1;183;0
WireConnection;97;0;107;0
WireConnection;107;0;1;0
WireConnection;107;1;108;0
WireConnection;184;0;2;0
WireConnection;184;1;185;0
WireConnection;183;0;182;0
WireConnection;183;1;167;0
WireConnection;0;0;184;0
WireConnection;0;10;184;0
ASEEND*/
//CHKSM=345C68EF118809E74B46EA2D09EF9BC800D87310